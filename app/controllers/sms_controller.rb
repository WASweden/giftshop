class SmsController < ApplicationController
  def new
    customer = make_order("regular")
    redirect_to customer_url(customer.token)
  end

  def new_xmas
    customer = make_order("xmas")
    redirect_to customer_url(customer.token)
  end

  def new_small
    customer = make_order("regular_small")
    redirect_to customer_url(customer.token)
  end

  def new_xmas_small
    customer = make_order("xmas_small")
    redirect_to customer_url(customer.token)
  end

  private

  def make_order(subtype = "regular")
    email = "sms-#{SecureRandom.urlsafe_base64(8)}@example.com"

    donor = Donor.new(email: email, first_name: 'SMS', last_name: 'SMS')
    amount = 200
    amount = 100 if subtype == 'regular_small' || subtype == 'xmas_small'
    subtype = 'xmas' if subtype == 'xmas_small'
    subtype = 'regular' if subtype == 'regular_small'

    order = Order.new
    order.order_id = Order.completed.maximum(:order_id) ? Order.completed.maximum(:order_id) + 1 : 1
    order.paid_at = Time.zone.now
    order.payment_type = 'sms'
    order.order_items.new(quantity: amount, product_quantity: 1, product: 'DigitalCard', subtype: subtype)
    order.total = order.calculate_total

    donor.order = order
    donor.save!
    donor.order.order_items.first.convert_to_cards

    customer = Customer.create!(email: email)
    customer
  end
end
