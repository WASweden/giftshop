class OrdersController < ApplicationController
  include NewCart
  before_action :current_cart

  def new
    @donor = @order.donor ? @order.donor : @order.build_donor
    # Get Giftcards for companies only (= 'foretag'):
    #@giftcards = Giftcard.where("in_which_store = 'foretag'")
    @giftcards = Giftcard.all
  end

  def update
    @order.update(order_params)

    order_items_with_zero_product_quantity = @order.order_items.find_by(product_quantity: 0)
    if order_items_with_zero_product_quantity
      order_items_with_zero_product_quantity.destroy
    end

    redirect_to root_path
  end

  private

  def order_params
    params.require(:order).permit(:id, order_items_attributes: [:id, :product_quantity])
  end
end
