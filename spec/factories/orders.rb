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

FactoryGirl.define do
  factory :order, class: Order do
    association :donor, factory: [:donor_person, :donor_company].sample

    factory :order_with_items, class: Order do
      association :donor, factory: :donor_person

      after(:create) do |order, evaluator|
        create_list(:order_item, 5, order: order)
      end
    end
  end
end
