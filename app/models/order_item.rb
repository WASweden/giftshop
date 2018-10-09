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

class OrderItem < ActiveRecord::Base
  belongs_to :order

  validates :quantity, numericality: { greater_than_or_equal_to: 20, less_than_or_equal_to: 1_000_000_000 }
  validates :product_quantity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000_000_000 }

  def price
    if product == "DigitalCard" || product == "Extra"
      (quantity * Card::DROPLET_PRICE) * product_quantity
    else
      ((quantity * Card::DROPLET_PRICE) + AnalogCard::PRINTED_PRICE) * product_quantity
    end
  end

  def convert_to_cards
    product_quantity.times {
      order.cards.create!(quantity: quantity, type: product, subtype: subtype)
    }
    order.update_card_counts!
  end
end
