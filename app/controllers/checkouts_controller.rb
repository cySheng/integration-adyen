class CheckoutsController < ApplicationController
  def new
    @payment_methods_response = Integration::Adyen::Checkout.generate_payment_methods
  end

  def create
    @checkout = Integration::Adyen::Checkout.generate_payment_request(params["paymentMethod"])
  end

  private
  def pay_params

  end
end
