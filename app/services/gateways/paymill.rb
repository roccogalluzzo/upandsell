module Gateways::Paymill

  @config = Upandsell::Application.config.paymill

  def self.pay(product, payer)
    Paymill.api_key = User.find(product.user_id).credit_card_token
    payment = Paymill::Payment.create(token: payer[:token])

    pay = Paymill::Transaction.create(
      amount: product.price,
      currency: product.price_currency.upcase,
      payment: payment.id
          # fee_amount: ((product.price * 4) / 100),
         # fee_payment: payment.id
         )

    return {token: pay.id, card_type: pay.payment['card_type'], status: 'completed'}
  end

  def self.subscribe(token)
    Paymill.api_key = '6770e56d99744c81f414d04aa1c7a162'
    client = Paymill::Client.create(email: current_user.email)
    payment = Paymill::Payment.create(token: token client: client.id)
    Paymill::Subscription.create(client: client.id,
      offer: "offer_6f6badd18f9ebdc5fa58",
      payment: payment.id)
  end

  def self.connect_url
    query = { client_id: @config[:client_id], scope: @config[:scope],
      response_type: 'code'}.to_query
      URI::HTTPS.build(host: 'connect.paymill.com',
        path: '/en-gb/authorize', query: query).to_s
    end

    def self.connect
      body = {
        client_id: @config[:client_id],
        client_secret: @config[:client_secret],
        grant_type: "authorization_code",
        code: auth_code
        }.to_query

        uri = URI::HTTPS.build(host: 'connect.paymill.com',
          path: '/token')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body =  body
        response = ActiveSupport::JSON.decode(http.request(request).body)

        current_user.connect_credit_card(response)
      end

      def self.refresh_token(refresh_token)

       body = {
        client_id: @config[:client_id],
        client_secret: @config[:client_secret],
        grant_type: "refresh_token",
        refresh_token: refresh_token,
        scope:  config[:scope]
        }.to_query

        # TODO complete
      end
    end