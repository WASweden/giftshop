class OrderItemsController < ApplicationController
  include NewCart
  before_action :current_cart

  # When user clicks "Beställ", new OrderItem is created
  # and added to the cart ("Varukorg")
  def create
    current_item = @order.order_items.find_by(
      order_id: params[:order_item][:order_id],
      product: params[:order_item][:product],
      subtype: params[:order_item][:subtype],
      quantity: params[:order_item][:quantity]
    )

    if current_item
      current_item.product_quantity += params[:order_item][:product_quantity].to_i
      current_item.save
    else
      @order.order_items.create(order_item_params)
    end

    redirect_to root_path
  end

  def destroy
    @order.order_items.find(params[:id]).destroy

    redirect_to root_path
  end

  private

  def order_item_params
    params.require(:order_item).permit(:order_id, :product_quantity, :product, :quantity, :subtype)
  end
end
