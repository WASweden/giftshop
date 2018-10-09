class PurchaseOrderStripe

  attr_reader :errors

  def self.call(order, stripe_token)
    new(order, stripe_token).call
  end

  def initialize(order, stripe_token)
    @errors = []
    @order = order
    @stripe_token = stripe_token
  end

  def call
    stripe_charge(@stripe_token)

    if @errors.empty? && @order.save
      # OrderMailer.delay.confirmation(@order.id)
      OrderMailer.delay.receipt(@order.id)
      true
    end
  end

  private

  def stripe_charge(stripe_token)
    response = Stripe::Charge.create(
      :amount      => @order.calculate_total * 100,
      :description => @order.donor.email,
      :currency    => 'sek',
      :card        => stripe_token,
      :metadata    => {
        :id  => @order.id
      }
    )

    @order.update(
      order_id: Order.completed.maximum(:order_id) ? Order.completed.maximum(:order_id) + 1 : 1,
      stripe_charge_id: response.id,
      total: response.amount / 100,
      paid_at: Time.at(response.created)
    )

  rescue Stripe::CardError => error
    @errors << error.message
  rescue Stripe::InvalidRequestError, Stripe::StripeError
    @errors << 'Något gick fel med betalningen. Försök igen senare'
  end

  def set_paid_at
    @order.paid_at = Time.zone.now
  end
end
