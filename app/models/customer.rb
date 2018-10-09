# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  token      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Customer < ActiveRecord::Base
  before_create :generate_token

  default_scope { where(arel_table[:created_at].gt(Time.now - 48.hour)) }

  validates_format_of :email,
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                      :allow_blank => false

  validate :customer_email

  def donor
    Donor.where(email: email).joins(:order).merge(Order.completed).order(created_at: :desc).limit(1).take
  end

  def orders
    Order.completed.joins(:donor).where(donors: { email: email }).order(created_at: :desc)
  end

  def find_card(token)
    Card.unsent.where(token: token).joins(:order).merge(orders).take!
  end

  private

  def customer_email
    errors.add(:email, 'is not a customer') unless donor
  end

  def generate_token
    self.token = loop do
      token = SecureRandom.urlsafe_base64(16)
      break token unless self.class.exists?(token: token)
    end
  end
end
