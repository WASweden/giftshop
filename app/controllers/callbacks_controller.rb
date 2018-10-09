class CallbacksController < ApplicationController
  SWISH_IPS = ['194.242.111.220'.freeze, '213.132.115.94'.freeze].freeze
  before_action :authenticate_stripe, only: [:stripe]
  before_action :filter_swish_ip, only: [:swish]
  skip_before_action :verify_authenticity_token

  def stripe
    event = stripe_params

    case event[:type]
    when 'charge.succeeded'
      # Occurs whenever a new charge is created and is successful.
    when 'charge.faled'
      # Occurs whenever a failed charge attempt occurs.
    when 'charge.refunded'
      # Occurs whenever a charge is refunded, including partial refunds.
    when 'charge.captured'
      # Occurs whenever a previously uncaptured charge is captured.
    when 'charge.updated'
      # Occurs whenever a charge description or metadata is updated.
    end

    render nothing: true
  end

  def swish
    payment = SwishPayment.find_by(payment_id: swish_params['id'])
    payment.update(info: swish_params)
    order = payment.order
    order.update_for_swish!

    if order.completed?
      order.order_items.each do |order_item|
        order_item.convert_to_cards
      end
    end

    head :ok
  end

  private

  def stripe_params
    params.require(:callback)
  end

  def authenticate_stripe
    render nothing: true, status: :unauthorized unless params[:key].eql?('wGco8pgV7uLPkA')
  end

  def filter_swish_ip
    render nothing: true, status: :unauthorized unless SWISH_IPS.include?(request.remote_ip)
  end

  def swish_params
    params.require(:callback)
  end
end
