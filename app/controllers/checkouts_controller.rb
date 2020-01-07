class CheckoutsController < ApplicationController
  before_action :set_adyen_api

  def new
    @payment_methods_response = @adyen_api.generate_payment_methods
  end

  def create
    @payment = @adyen_api.generate_3ds2_payment_request(
      payment_method: payment_method_params,
      browser_info: browser_info_params,
      ip_address: request.remote_ip,
      root_url: root_url,
      return_url: success_checkouts_url
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
