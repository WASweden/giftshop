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

FactoryGirl.define do
  factory :digital_card, class: DigitalCard do
    text { Faker::Lorem.paragraph }
    quantity  { Random.rand(20..100) }
    receiver { Faker::Internet.email }
  end

  factory :analog_card, class: AnalogCard do
    text { Faker::Lorem.paragraph }
    quantity  { Random.rand(20..100) }
    receiver { Faker::Internet.email }
  end
end
