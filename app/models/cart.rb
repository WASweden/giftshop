class Cart
  def initialize(session)
    @session = session
  end

  def add(card)
    order.cards << card
  end

  def remove(card)
    order.cards.destroy(card)
  end

  def destroy
    @order, @session[:cart_id] = nil

    true
  end

  def cards
    if cart_exists?
      order.cards
    else
      []
    end
  end

  def order
    @order ||= create_order
  end

  def empty?
    if cart_exists?
      cards.count > 0 ? false : true
    else
      true
    end
  end

  def find_card(token)
    Card.where(token: token, order_id: @session[:cart_id]).take!
  end

  private

  def create_order
    Order.find(@session[:cart_id])

    rescue ActiveRecord::RecordNotFound
      @order = Order.create!
      @session[:cart_id] = @order.id

      @order
  end

  def cart_exists?
    @session[:cart_id] ? true : false
  end
end
