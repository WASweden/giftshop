# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :giftcard do
    name "MyString"
    description "MyText"
    category "MyString"
    in_which_store "MyString"
    amount 1
  end
end
