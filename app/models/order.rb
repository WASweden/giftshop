# == Schema Information
#
# Table name: orders
#
#  id                         :integer          not null, primary key
#  payment_type               :string(255)      default("card")
#  stripe_charge_id           :string(255)
#  paid_at                    :datetime
#  total                      :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  order_id                   :integer
#  digital_cards_count        :integer          default(0)
#  analog_cards_count         :integer          default(0)
#  analog_cards_regular_count :integer          default(0)
#  analog_cards_xmas_count    :integer          default(0)
#

class Order < ActiveRecord::Base
  attr_accessor :stripe_token

  has_many :cards
  has_many :order_items
  has_many :swish_payments
  has_one :donor

  validates_associated :donor

  PAYMENT_TYPES = { :card => 'card', :invoice => 'invoice', :sms => 'sms', :swish => 'swish' }
  INVOICABLE_MINIMUM = 5000
  XMAS_BUNDLE_MINIMUM = 3000

  accepts_nested_attributes_for :donor, :allow_destroy => true
  accepts_nested_attributes_for :order_items, :allow_destroy => true

  scope :pending,   -> { where(paid_at: nil) }
  scope :completed, -> { where.not(paid_at: nil) }
  scope :exportable, -> { where.not(paid_at: nil, payment_type: 'sms') }
  scope :company, -> { joins(:donor).where("donors.donor_type = 'company'") }

  scope :digital_cards, -> { joins(:cards).where(cards: { type: DigitalCard }) }
  scope :analog_cards,  -> { joins(:cards).where(cards: { type: AnalogCard }) }

  validates :payment_type, inclusion: { in: PAYMENT_TYPES.map { |_k, v| v } }

  def swish_payment
    payments = SwishPayment.where(order_id: id).all.order(created_at: :desc)
    payment = payments.find_by("info->>'status' = 'PAID'")
    return payment if payment
    return payments.first
  end

  def update_for_swish!
    if swish_payment.status_valid?
      self.update(
        paid_at: swish_payment.date_created,
        total: calculate_total
      )
    end
  end

  def calculate_total
    order_items.reduce(0) do |total, item|
      total + item.price
    end
  end

  def total_card_count
    order_items.reduce(0) do |total, item|
      total + item.product_quantity
    end
  end

  def update_card_counts!
    digital_total = 0
    analog_total = 0
    analog_regular_total = 0
    analog_xmas_total = 0
    cards.each do |card|
      digital_total += 1 if card.type == "DigitalCard"

      if card.type == "AnalogCard"
        analog_total += 1
        analog_regular_total += 1 if card.subtype["regular"]
        analog_xmas_total += 1 if card.subtype["xmas"]
      end
    end
    self.digital_cards_count = digital_total
    self.analog_cards_count = analog_total
    self.analog_cards_regular_count = analog_regular_total
    self.analog_cards_xmas_count = analog_xmas_total
    self.save!
  end

  def empty?
    order_items.count > 0 ? false : true
  end

  def payment_type=(payment_type)
    write_attribute(:payment_type, PAYMENT_TYPES[payment_type.to_sym])
  end

  def invoicable?
    calculate_total >= INVOICABLE_MINIMUM
  end

  def qualifies_for_xmas_bundle?
    calculate_total >= XMAS_BUNDLE_MINIMUM
  end

  def qualifies_for_company_xmas_bundle?
    donor && donor.donor_type == 'company' && qualifies_for_xmas_bundle?
  end

  def has_digital_cards?
    order_items.each do |i|
      return true if i.product == 'DigitalCard'
    end

    return false
  end

  def has_analog_cards?
    order_items.each do |i|
      return true if i.product == 'AnalogCard'
    end

    return false
  end

  def has_xmas_items?
    order_items.each do |i|
      return true if i.subtype["xmas"]
    end

    return false
  end

  def has_unsent_cards?
    cards.each do |c|
      return true if c.sent_at == nil
    end

    return false
  end

  def find_card(token)
    Card.where(token: token)
  end

  def completed?
    paid_at.present?
  end
end
