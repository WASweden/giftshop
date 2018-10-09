# == Schema Information
#
# Table name: order_items
#
#  id               :integer          not null, primary key
#  quantity         :integer
#  product          :string
#  product_quantity :integer
#  order_id         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  subtype          :string
#

FactoryGirl.define do
  factory :order_item do
    order
    quantity { rand(1000) + 20 }
    product ['DigitalCard', 'AnalogCard', 'Extra'].sample
    product_quantity { rand(10) + 1 }
  end
end

