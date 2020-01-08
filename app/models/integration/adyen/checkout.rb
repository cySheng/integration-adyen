class Integration::Adyen::Checkout
  # params that are regularly used 
  # STANDARD_PARAMS = {}

  # setup configuration to adyen's api
  def initialize 
    @adyen = ::Adyen::Client.new
    @adyen.checkout.version = 51
    @adyen.api_key = ENV["API_KEY"]
    @adyen.env = :test
  end

  def request_payment_methods
    request = @adyen.checkout.payment_methods({
      :merchantAccount => ENV["MERCHANT_ACCOUNT"],
      :countryCode => 'NL',
      :amount => {
        :currency => 'EUR',
        :value => 1000
      },
      :channel => 'Web'
    })

    request.response
  end

  def post_payment(payment_method:, browser_info:, ip_address:, root_url:, return_url:)
    request = @adyen.checkout.payments({
      :amount => {
        :currency => "EUR",
        :value => 12100
      },
      :shopperIP => ip_address,
      :channel => "Web",
      :reference => "12345",
      :additionalData => {
        :allow3DS2 => "true"
      },
      "billingAddress": {
        "country": "US",
        "city": "New York",
        "street": "Redwood Block",
        "houseNumberOrName": "37C",
        "stateOrProvince": "NY",
        "postalCode": "10039"
      },
      "shopperEmail": {
        "shopperEmail": 'testing112312@gmail.com'
      },
      :paymentMethod => payment_method["paymentMethod"].to_h,
      #paymentMethod: {
      #  "type": "scheme",
      #  "holderName": "John Smith",
      #  "number": "4545 4545 4545 4545",
      #  "expiryMonth": "03",
      #  "expiryYear": "2030",
      #  "cvc": "737"
      #},
      :origin => root_url,
      :returnUrl => return_url,
      :merchantAccount => ENV["MERCHANT_ACCOUNT"],
      :browserInfo => browser_info
    })

    request.response
  end

  def post_payment_details(payment_details)
    request = @adyen.checkout.payments.details(payment_details)

    request.response
  end
end
