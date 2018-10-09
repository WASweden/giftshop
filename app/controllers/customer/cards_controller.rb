class Customer::CardsController < ApplicationController
  def edit
    @customer = Customer.find_by!(token: params[:customer_id])
    @card = @customer.find_card(params[:id])
    @card.send_at ||= Date.today
  end

  def update
    @customer = Customer.find_by!(token: params[:customer_id])
    @card = @customer.find_card(params[:id])

    if @card.update_attributes(card_params)
      @card.save
      @card.reschedule!

      if card_params[:send_to_donor] && @customer.email["@example.com"] # system-generated email
        @card.order.donor.update_attributes!(email: card_params[:receiver])
        @customer.update_attributes!(email: card_params[:receiver])
      end

      redirect_to customer_url(@customer.token)
    else
      render 'edit'
    end
  end

  private

  def card_params
    params.require(:card).permit(
      :text, :receiver, :send_at,
      :send_to_donor, :type, :subtype
    )
  end
end
