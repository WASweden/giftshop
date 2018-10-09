#we might need to use memoize pattern in the future in some methods
module SessionCart
  extend ActiveSupport::Concern

  included do
    before_filter :initialize_cart
  end

  def initialize_cart
    @has_cards = false
    return if session[:order_id].blank?

    @cart = Order.find_by(id: session[:order_id])
    return if @cart.nil?

    @has_cards = true if @cart.cards.count > 0
    @has_no_donor = @cart.donor.nil?
  end

  def order
    return Order.find_by(id: session[:order_id]) if order_exists
  end
  alias_method :cart, :order

  def find_or_create_order
    return Order.find_by(id: session[:order_id]) if order_exists

    (order = Order.new).save
    session[:order_id] = order.id
    return order
  end

  #always update your cart when you 'render' instead of regular redirect
  def update_cart
    initialize_cart
  end

  def delete_cart
    session.delete(:order_id)
  end

  #only when you call 'render' afterwards
  def delete_cart!
    session.delete(:order_id)
    [:@has_cards, :@cart, :@has_no_donor].each do |v|
      remove_instance_variable(v)
    end
    initialize_cart
  end

  private

  def order_exists
    session[:order_id] && Order.find_by(id: session[:order_id])
  end
end
