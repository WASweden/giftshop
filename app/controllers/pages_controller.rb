class PagesController < ApplicationController
  include SessionCart

  def index
    @cart = Cart.new(session)
    @order = @cart.order
    @donor = @order.donor ? @order.donor : @order.build_donor
  end

  def info
    @examples = Example.active.order(amount: :asc)
  end

  def help
  end

  def integritetspolicy
  end

  def dev_card
    render :layout => 'card'
  end

  def card_private_standard
    render :layout => 'card'
  end

  def card_private_xmas
    render :layout => 'card'
  end

  def card_business_standard
    render :layout => 'card'
  end

  def card_business_standard_en
    render :layout => 'card'
  end

  def card_business_xmas
    render :layout => 'card'
  end

  def dev_design
  end
end
