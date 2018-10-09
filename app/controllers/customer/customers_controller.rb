class Customer::CustomersController < ApplicationController
  def index
    @customer = Customer.new
  end

  def show
    @customer = Customer.find_by!(token: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :customers, error: 'Länken är ogiltig. Försök igen genom att begära utt ett nytt.'
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      CustomerMailer.delay.token(@customer.id)
      redirect_to :customers, notice: 'Vi har skickat länken till din e-postadress.'
    else
      render :index
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:email)
  end
end
