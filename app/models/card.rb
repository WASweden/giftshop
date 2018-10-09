# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  order_id      :integer
#  type          :string(255)
#  text          :text
#  quantity      :integer
#  receiver      :string(255)
#  send_to_donor :boolean          default(FALSE)
#  send_at       :datetime
#  sent_at       :datetime
#  token         :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#  form_type     :string(255)
#  job_id        :string(255)
#  subtype       :string
#

class Card < ActiveRecord::Base
  DROPLET_PRICE = 1
  PRINTED_PRICE = 30

  MINIMUM_QUANTITY = 20

  belongs_to :order

  before_create :generate_token

  scope :sent, -> { where.not(sent_at: nil) }
  scope :unsent, -> { where(sent_at: nil) }

  validates :quantity, presence: true
  validates :send_at, presence: true, unless: :new_record?

  validates :quantity,
            :numericality => { greater_than_or_equal_to: MINIMUM_QUANTITY }

  validates_format_of :receiver,
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                      :allow_blank => true

  validates :receiver,
            presence: true,
            unless: proc { |card| card.send_to_donor? || card.new_record? }

  validates :text, length: { maximum: 400 }

  validates :send_to_donor, inclusion: [true, false]

  def receiver
    return order.try(:donor).try(:email) if send_to_donor
    super
  end

  def to_s
    self.class.model_name.human
  end

  def filled_out?
    text.present? && receiver.present?
  end

  def ready_to_be_sent?
    sent_at.nil? && send_at.present? && type == 'DigitalCard' && filled_out?
  end


  def reschedule!
    return unless ready_to_be_sent?
    Sidekiq::Status::unschedule job_id if job_id
    if send_at <= Time.zone.now
      self.send_at = Time.zone.now + 5.minutes
      self.job_id = CardWorker.perform_in(self.send_at, id)
    else
      self.job_id = CardWorker.perform_at(send_at.to_i, id)
    end
    self.save!
  end

  private

  def generate_token
    self.token = loop do
      token = SecureRandom.urlsafe_base64(8)
      break token unless self.class.exists?(token: token)
    end
  end
end
