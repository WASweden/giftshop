class Company::OrdersController < OrdersController

  # params.each do |key,value|
  #   Rails.logger.warn "Param #{key}: #{value}"
  # end
  #

  def update
    @order.update(order_params)

    redirect_to company_path
  end
end
