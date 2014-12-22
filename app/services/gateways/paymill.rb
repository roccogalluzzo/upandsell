module Gateways::Paymill

  @config = Rails.application.secrets.paymill

  def self.pay(product, payer)
    Paymill.api_key = User.find(product.user_id).credit_card_token
    payment = Paymill::Payment.create(token: payer[:token])

    pay = Paymill::Transaction.create(
      amount: payer[:new_price].cents || product.price.cents,
      currency: product.price_currency.upcase,
      payment: payment.id)
    return {token: pay.id, card_type: pay.payment['card_type'], status: 'completed'}
  end

  def self.refund(token, amount, user_id)
    Paymill.api_key = User.find(user_id).credit_card_token
    Paymill::Refund.create id: token, amount: amount
  end

  def self.subscribe(token)
   Paymill.api_key = '6770e56d99744c81f414d04aa1c7a162'
   client = Paymill::Client.create(email: current_user.email)
   payment = Paymill::Payment.create(token: token, client: client.id)
   Paymill::Subscription.create(client: client.id,
    offer: "offer_6f6badd18f9ebdc5fa58",
    payment: payment.id)
 end
end
