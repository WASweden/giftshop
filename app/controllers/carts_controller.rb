class CartsController < ApplicationController
  include NewCart
  before_action :current_cart

  def update
    if @order.update(order_params)
      @donor = @order.donor
      if @order.payment_type.eql?(Order::PAYMENT_TYPES[:card])
        if PurchaseOrderStripe.call(@order, @order.stripe_token)
          @order.order_items.each do |order_item|
            order_item.convert_to_cards
          end

          redirect_to complete_checkout_url
        else
          redirect_to company_path, flash: { notice: "Något gick fel med betalningen. Var vänlig att prova med ett annat betalkort." } if @donor.donor_type == :company
          redirect_to root_path, flash: { notice: "Något gick fel med betalningen. Var vänlig att prova med ett annat betalkort." }
        end
      elsif @order.payment_type.eql?(Order::PAYMENT_TYPES[:invoice])
        if PurchaseOrderInvoice.call(@order)
          @order.order_items.each do |order_item|
            order_item.convert_to_cards
          end

          redirect_to complete_checkout_url
        else
          redirect_to company_path if @donor.donor_type == :company
          redirect_to root_path
        end
      elsif @order.payment_type.eql?(Order::PAYMENT_TYPES[:swish])
        result = SwishService.perform(@order)
        if result.success?
          redirect_to swish_checkout_url
        else
          redirect_to company_path, flash: { notice: result.errors.to_s } if @donor.donor_type == :company
          redirect_to root_path, flash: { notice: result.errors.to_s }
        end
      end
    else
      error_message = @order.errors.full_messages.join(". ")

      if @order.donor.donor_type = "person"
        redirect_to root_path, flash: { notice: error_message }
      else
        redirect_to company_path, flash: { notice: error_message }
      end
    end
  end

  private
  def order_params
    params.require(:order).permit(
      :payment_type,
      :stripe_token,
      :swish_number,
      donor_attributes: [
        :donor_type, :first_name, :last_name, :company,
        :email, :org_number, :phone, :address, :post_code,
        :city, :country_code, :company_code
      ]
    )
  end
end
