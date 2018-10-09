module SwishHelpers
  def self.callback_params(hash = {})
    {
      "id"=>"7D815A4450C044CC8F9E8E792A004EB1",
      "amount"=>"600.0",
      "status"=>"PAID",
      "message"=>"WaterAid Gåvoshop",
      "currency"=>"SEK",
      "datePaid"=>"2018-03-09T13:20:49.978Z",
      "errorCode"=>nil,
      "payeeAlias"=>"1231181189",
      "payerAlias"=>"46739123123",
      "callbackUrl"=>"https://db363f80.ngrok.io/callbacks/swish",
      "dateCreated"=>"2018-03-09T13:20:49.978Z",
      "errorMessage"=>nil,
      "paymentReference"=>"4C2E062F4FD84147B57843B04F9E4DFF",
      "payeePaymentReference"=>"0123456789"
    }.merge(hash)
  end
end
