# == Schema Information
#
# Table name: swish_payments
#
#  id         :integer          not null, primary key
#  payment_id :string           not null
#  info       :jsonb            default({}), not null
#  order_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SwishPayment < ActiveRecord::Base
  belongs_to :order

  validates :payment_id, presence: true

  def status
    info['status']
  end

  def status_valid?
    info['errorCode'].nil? && info['errorMessage'].nil? && paid?
  end

  def error
    return nil if status_valid?

    details = error_details.nil? ? nil : "(#{error_details})"
    return "Status: #{status} #{details}"
  end

  def error_details
    return nil if info['errorCode'].nil? && info['errorMessage'].nil?


    return "#{info['errorCode']} - #{info['errorMessage']}"
  end

  def paid?
    info['status'] == 'PAID'
  end

  def pending?
    info.blank?
  end

  def date_created
    return DateTime.parse(info['dateCreated']) if info['dateCreated']
    return created_at
  end
end

