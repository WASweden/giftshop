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

require 'rails_helper'

describe Card do
  it 'is invalid without quantity' do
    expect(FactoryGirl.build(:digital_card, quantity: nil)).
      to have_at_least(1).errors_on(:quantity)
  end

  it 'is invalid with negative quantity' do
    expect(FactoryGirl.build(:digital_card, quantity: -1)).
      to have_at_least(1).errors_on(:quantity)
  end

  it "is invalid with receiver's wrong email format" do
    expect(FactoryGirl.build(:digital_card, receiver: 'lalala@la')).
      to have_at_least(1).errors_on(:receiver)
  end
end
