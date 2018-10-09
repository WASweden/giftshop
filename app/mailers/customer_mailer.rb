class CustomerMailer < ActionMailer::Base
  def token(customer_id)
    @customer = Customer.find(customer_id)
    mail(to: @customer.email, subject: 'Dina beställningar')
  end
end
