class CustomerMailerPreview < ActionMailer::Preview
  def token
    CustomerMailer.token(Customer.last.id)
  end
end
