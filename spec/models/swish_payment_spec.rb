# == Schema Information
#
# Table name: swish_payments
#
#  id         :integer          not null, primary key
#  payment_id :string           not null
#  info       :jsonb            default({}), not null
#  order_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Order do
  context "is invalid without payment_id" do
    it "returns true" do
      expect(FactoryGirl.build(:swish_payment).valid?).to eq true
    end
  end
end
