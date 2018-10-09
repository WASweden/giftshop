module NewCart
  extend ActiveSupport::Concern

  def clear_cart
    session.delete(:cart_id)
  end

  private

  def current_cart
    @order = Order.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @order = Order.create!
      session[:cart_id] = @order.id

    @order
  end
end
