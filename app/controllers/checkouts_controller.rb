class CheckoutsController < ApplicationController
  before_action :set_adyen_api

  def new
    @payment_methods_response = @adyen_api.request_payment_methods
  end

  def create
    @payment = @adyen_api.post_payment(
      payment_method: payment_method_params,
      browser_info: browser_info_params,
      ip_address: request.remote_ip,
      root_url: root_url,
      return_url: success_checkouts_url
    )

    if @payment.has_key?('action')
      render json: @payment.action
    elsif @payment.has_key?('errorCode')
      render 'checkouts/error'
    else
      case @payment.resultCode
      when 'Received', 'Authorised', 'Pending'
        redirect_to '/checkouts/success'
      else
        p @payment.resultCode
      end
    end
  end

  def payment_details
    @payment = @adyen_api.post_payment_details(params)
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
