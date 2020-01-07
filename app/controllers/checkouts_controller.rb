class CheckoutsController < ApplicationController
  before_action :set_adyen_api

  def new
    @payment_methods_response = @adyen_api.generate_payment_methods
  end

  def create
    @payment = @adyen_api.generate_3ds2_payment_request(
      payment_method_params,
      browser_info_params,
      request.remote_ip
    )

    render json: @payment.action
  end

  def payment_details

  end

  def success

  end

  private
  def set_adyen_api
    @adyen_api = Integration::Adyen::Checkout.new
  end

  def payment_method_params
    params.permit(paymentMethod: {})
  end

  def browser_info_params
    params.permit(browserInfo: {})
  end
end
