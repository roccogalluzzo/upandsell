module Gateways::Paymill

  @config = Rails.application.secrets.paymill

  def self.pay(product, payer)
    Paymill.api_key = User.find(product.user_id).credit_card_token
    payment = Paymill::Payment.create(token: payer[:token])

    pay = Paymill::Transaction.create(
      amount: product.price_cents,
      currency: product.price_currency.upcase,
      payment: payment.id
      )
    return {token: pay.id, card_type: pay.payment['card_type'], status: 'completed'}
  end

  def self.subscribe(token)
    Paymill.api_key = '6770e56d99744c81f414d04aa1c7a162'
    client = Paymill::Client.create(email: current_user.email)
    payment = Paymill::Payment.create(token: token, client: client.id)
    Paymill::Subscription.create(client: client.id,
      offer: "offer_6f6badd18f9ebdc5fa58",
      payment: payment.id)
  end

  def self.connect_url
    query = { client_id: @config['client_id'], scope: @config['scope'],
      response_type: 'code'}.to_query
      URI::HTTPS.build(host: 'connect.paymill.com',
        path: '/en-gb/authorize', query: query).to_s
    end

    def self.connect(user, code)
      body = {
        client_id: @config['client_id'],
        client_secret: @config['client_secret'],
        grant_type: "authorization_code",
        code: code
        }.to_query

        uri = URI::HTTPS.build(host: 'connect.paymill.com',  path: '/token')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body =  body
        response = ActiveSupport::JSON.decode(http.request(request).body)
        user.connect_credit_card(response)
      end

      def self.refund
        Paymill::Refund.create id: "tran_f5bc741dc3809ad3c62fd255e60c",
        amount: 4200
      end
    end
