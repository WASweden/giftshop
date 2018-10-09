class CardsController < ApplicationController
  include NewCart
  include DocRaptorable
  before_action :current_cart

  ##########################################
  # Action used to show the digital card to
  # the final receiver
  ##########################################
  def show
    @card = Card.joins(:order).merge(Order.completed).find_by!(token: params[:id])
    @preview = params[:preview] || false
    @customer_token = params[:customer] || false

    respond_to do |format|
      format.html { render :layout => 'card' }
      format.pdf { doc_raptor_send(name: view_context.card_title(@card)) }
    end
  end

  ##########################################
  # Actions used for the order flow
  #
  ##########################################
  def new
    @card = DigitalCard.new(quantity: 200, form_type: 'private')
    @examples = Example.active.order(amount: :asc)
  end

  def new_company
    @card = DigitalCard.new(quantity: 2000, form_type: 'company')
    @examples = Example.active.order(amount: :asc)
  end

  def edit
    @card = Card.joins(:order).merge(Order.completed).find_by!(token: params[:id])
    @examples = Example.active.order(amount: :asc)
  end

  def confirmation
    @card = Card.joins(:order).merge(Order.completed).find_by!(token: params[:id])
  end

  def preview
    @card = "Card.joins(:order).merge(Order.completed).find_by!(token: params[:id])"
    @preview = params[:preview] || false
    render :show, :layout => 'card'
  end

  def create
    if card_params[:type]
      @card = Card.new(card_params)
    else
      @card = DigitalCard.new(card_params)
    end
    if @cart.add @card
      redirect_to confirmation_card_url(@card.token)
    else
      render 'new'
    end
  end

  def update
    @card = @order.find_card(params[:id])
    if @card.update(card_params)
      redirect_to @order
    else
      render 'edit'
    end
  end

  private

  def card_params
    params.require(:card).permit(
      :text, :quantity, :receiver, :send_at,
      :send_to_donor, :printed, :type, :subtype, :form_type
    )
  end
end
