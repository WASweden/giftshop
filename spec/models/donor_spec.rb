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

require 'rails_helper'

describe Donor do

  it 'is invalid without an email' do
    expect(FactoryGirl.build(:donor_person, email: nil)).
      to have_at_least(1).errors_on(:email)
  end

  it 'is valid with a duplicate email address' do
    Donor.create(
      first_name: 'Joe', last_name: 'Tester', email: 'tester@example.com'
    )
    donor = Donor.new(
      first_name: 'Jane', last_name: 'Tester', email: 'tester@example.com'
    )

    expect(donor).to be_valid
  end

end
