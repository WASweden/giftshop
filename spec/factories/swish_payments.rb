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

FactoryGirl.define do
  factory :swish_payment do
    info_data = {
      "id"=>"7CF2324218AA42B385A2636E3F42C8E9",
      "amount"=>600.0,
      "status"=>"PAID",
      "message"=>"WaterAid Gåvoshop",
      "currency"=>"SEK",
      "datePaid"=>"2018-03-12T13:27:27.222Z",
      "errorCode"=>nil,
      "payeeAlias"=>"1231181189",
      "payerAlias"=>"46123456789",
      "callbackUrl"=>"https://f9655127.ngrok.io/callbacks/swish",
      "dateCreated"=>DateTime.now.utc.iso8601,
      "errorMessage"=>nil,
      "paymentReference"=>"B07BDE7733174139B98A81A2FF080379",
      "payeePaymentReference"=>"0123456789"
    }

    order

    payment_id { SecureRandom.hex }

    factory :swish_payment_successful do
      info { info_data }
    end

    factory :swish_payment_with_errors do
      info {
        info_data.merge({
          "status": "ERROR",
          "errorCode": "errorCodeExample",
          "errorMessage": "errorMessageExample"
        })
      }
    end
  end
end
