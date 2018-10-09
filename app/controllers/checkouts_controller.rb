class CheckoutsController < ApplicationController
  include NewCart
  before_action :current_cart

  def complete
    # Moved to CartsController
    # @order.order_items.each do |order_item|
    #   order_item.convert_to_cards
    # end

    if @order.donor
      @purchase = @order.cards
      @customer = Customer.create!(email: @order.donor.email) # TODO: This is an ugly hack

      OrderMailer.delay.analog_card_order(@order.id, admin_order_url(@order)) if @order.has_analog_cards?
      CreateKommedDonationWorker.perform_async(@order.id)
      clear_cart
    else
      redirect_to root_path
    end

    # redirect_to customer_url(@customer.token)
    # The view redirects instead
  end

  def swish_payment_status
    payment = @order.swish_payment
    render json: {
      completed: @order.completed?,
      error: payment && (payment.pending? ? nil : payment.error)
    }
  end

  private
  def charge_params
    params.require(:stripe_token)
  end
end
