# == Schema Information
#
# Table name: examples
#
#  id          :integer          not null, primary key
#  description :text
#  amount      :integer
#  country     :string(255)
#  active      :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class Example < ActiveRecord::Base
  validates :description, :country, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :active, -> { where(active: true) }
end
