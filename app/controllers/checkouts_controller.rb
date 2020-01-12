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
      render json: @payment
    else
      case @payment.resultCode
      when 'Received', 'Authorised', 'Pending'
        respond_to do |format|
          format.json { render json: @payment }
          format.html { redirect_to success_checkouts_path }
        end
      else
        render json: @payment
      end
    end
  end

  def payment_details
    @payment = @adyen_api.post_payment_details(params)
  end

  def success
    respond_to do |format|
      format.html
      format.json
    end
  end

  def error
    @error = params[:error]
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
