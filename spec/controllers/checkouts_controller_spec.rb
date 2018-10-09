require 'rails_helper'

RSpec.describe CheckoutsController, '#swish', :type => :controller do
  context "when Swish payment hasn't been made yet" do
    before do
      @payment = FactoryGirl.create(:swish_payment, {
        order: FactoryGirl.create(:order_with_items, payment_type: 'swish')
      })
    end

    it "returns completed as false" do
      get(:swish_payment_status)
      expect(JSON.parse(response.body, {:symbolize_names => true})).to eq({completed: false, error: nil})
    end
  end

  context "when Swish payment has been completed" do
    before do
      @payment = FactoryGirl.create(:swish_payment_successful, {
        order: FactoryGirl.create(:order_with_items, payment_type: 'swish')
      })
      @payment.order.update_for_swish!
    end

    it "returns completed as false" do
      session['cart_id'] = @payment.order.id
      get(:swish_payment_status)
      expect(JSON.parse(response.body, {:symbolize_names => true})).to eq({completed: true, error: nil})
    end
  end

  context "when Swish payment has errors" do
    before do
      @payment = FactoryGirl.create(:swish_payment_with_errors, {
        order: FactoryGirl.create(:order_with_items, payment_type: 'swish')
      })
    end

    it "returns completed as false" do
      session['cart_id'] = @payment.order.id
      get(:swish_payment_status)
      expect(JSON.parse(response.body, {:symbolize_names => true})).to eq({
        completed: false, error: "Status: ERROR (errorCodeExample - errorMessageExample)"
      })
    end
  end
end

