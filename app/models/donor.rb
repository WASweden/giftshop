# == Schema Information
#
# Table name: donors
#
#  id           :integer          not null, primary key
#  order_id     :integer
#  donor_type   :string(255)      default("person")
#  first_name   :string(255)
#  last_name    :string(255)
#  email        :string(255)
#  company      :string(255)
#  org_number   :string(255)
#  phone        :string(255)
#  address      :text
#  post_code    :string(255)
#  city         :string(255)
#  country_code :string(255)
#  newsletter   :boolean          default(TRUE)
#  created_at   :datetime
#  updated_at   :datetime
#

class Donor < ActiveRecord::Base
  belongs_to :order

  DONOR_TYPES = { :person => 'person', :company => 'company' }

  validates :donor_type, inclusion: { in: DONOR_TYPES.map { |_k, v| v } }

  validates :first_name, :last_name, :email, presence: true

  validates :company, :org_number,
            :presence => true,
            :if => proc { |donor| donor.donor_type == DONOR_TYPES[:company] }

  validates :address, :post_code, :city, :country_code,
            :presence => true,
            :if => proc { |donor| donor.order && donor.invoice_or_analog_card? }

  validates_format_of :email,
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                      :allow_blank => false

  validates :newsletter, inclusion: [true, false]

  def to_s
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def donor_type=(donor_type)
    write_attribute(:donor_type, DONOR_TYPES[donor_type.to_sym])
  end

  def invoice_or_analog_card?
    return true if self.order.payment_type.eql?(Order::PAYMENT_TYPES[:invoice])
    # change to order_items.cards
    self.order.cards.each do |c|
      return true if c.class.eql?(AnalogCard)
    end

    false
  end
end
