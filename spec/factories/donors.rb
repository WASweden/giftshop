# == Schema Information
#
# Table name: donors
#
#  id           :integer          not null, primary key
#  order_id     :integer
#  donor_type   :string(255)      default("person")
#  first_name   :string(255)
#  last_name    :string(255)
#  email        :string(255)
#  company      :string(255)
#  org_number   :string(255)
#  phone        :string(255)
#  address      :text
#  post_code    :string(255)
#  city         :string(255)
#  country_code :string(255)
#  newsletter   :boolean          default(TRUE)
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :donor_person, class: Donor do
    donor_type { Donor::DONOR_TYPES[:person] }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    post_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    country_code { 'SE' }
    newsletter { true }
    phone { '0739123123' }
  end

  factory :donor_company, class: Donor do
    donor_type { Donor::DONOR_TYPES[:company] }
    company  { Faker::Company.name }
    org_number { Faker::Company.duns_number }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    post_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    country_code { 'SE' }
    newsletter { true }
    phone { '+46739123123' }
  end
end
