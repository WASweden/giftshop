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

require 'rails_helper'

describe Order do
  describe "#has_xmas_items?" do
    subject(:order) { FactoryGirl.create(:order) }

    context "with xmas items" do
      it "returns true" do
        order.order_items << OrderItem.create!(product: "DigitalCard", subtype: "regular", quantity: 100, product_quantity: 100)
        order.order_items << OrderItem.create!(product: "DigitalCard", subtype: "xmas", quantity: 100, product_quantity: 100)

        expect(order.has_xmas_items?).to eq(true)
      end
    end

    context "with no xmas items" do
      it "returns false" do
        order.order_items << OrderItem.create!(product: "DigitalCard", subtype: "regular", quantity: 100, product_quantity: 100)
        order.order_items << OrderItem.create!(product: "DigitalCard", subtype: "regular-english", quantity: 100, product_quantity: 100)

        expect(order.has_xmas_items?).to eq(false)
      end
    end
  end
end
