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

  def generate_payment_methods
    response = @adyen.checkout.payment_methods({
      :merchantAccount => ENV["MERCHANT_ACCOUNT"],
      :countryCode => 'NL',
      :amount => {
        :currency => 'EUR',
        :value => 1000
      },
      :channel => 'Web'
    })

    response.response.to_json
  end

  def generate_3ds2_payment_request(payment_method, browser_info, ip_address)
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
      :origin => "http://localhost:3000",
      :returnUrl => "http://localhost:3000/checkouts/success",
      :merchantAccount => ENV["MERCHANT_ACCOUNT"],
      :browserInfo => browser_info
    })

    request.response
  end
end
