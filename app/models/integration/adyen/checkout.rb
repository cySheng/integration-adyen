class Integration::Adyen::Checkout < ApplicationRecord
  class << self
    def prepare_request
      @adyen = Adyen::Client.new
      @adyen.api_key = ENV["API_KEY"]
      @adyen.env = :test
    end

    def generate_payment_methods
      prepare_request

      response = @adyen.checkout.payment_methods({
        :merchantAccount => ENV["MERCHANT_ACCOUNT"],
        :countryCode => 'NL',
        :amount => {
          :currency => 'EUR',
          :value => 1000
        },
        :channel => 'Web'
      })

      # TBR
      response.response.to_json
    end

    def generate_payment_request(payment_method)
      prepare_request

      response = adyen.checkout.payments({
        :amount => {
          :currency => "EUR",
          :value => 1000
        },
        :shopperIP => "192.168.1.3",
        :channel => "Web",
        :reference => "12345",
        :additionalData => {
          :executeThreeD => "true"
        },
        :paymentMethod => payment_method,
        :returnUrl => "http://localhost:3000/checkout/confirmation",
        :merchantAccount => ENV["MERCHANT_ACCOUNT"],
        :browserInfo => {
          :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36",
          :acceptHeader => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"
        }
      })
    response
    end
  end
end
