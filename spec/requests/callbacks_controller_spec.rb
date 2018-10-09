require 'rails_helper'

RSpec.describe CallbacksController, '#swish', :type => :request do
  before do
    @payment_id = 'AB23D7406ECE4542A80152D909EF9F6B'
    stub_request(:post, /cpc.getswish.net/).to_return(
      status: 201, body: "", headers: {
        Location: "https://swicpc.bankgirot.se/swishcpcapi/api/v1/paymentrequests/#{@payment_id}"
      }
    )
    allow_any_instance_of(ActionDispatch::Request).to(
      receive(:remote_ip).and_return(CallbacksController::SWISH_IPS.last)
    )

    @order = FactoryGirl.create(:order, swish_number: '0123456789')
    @foo = SwishService.perform(@order)
  end

  it "updates the swish payment entry" do
    expect(SwishPayment.last.payment_id).to eq @payment_id
    expect(SwishPayment.last.info).to eq({})
    post('/callbacks/swish', {
      callback: SwishHelpers.callback_params({
        'id' => @payment_id
      })
    })
    expect(SwishPayment.last.info).to eq(
      SwishHelpers.callback_params({
        'id' => @payment_id
      })
    )
  end
end
