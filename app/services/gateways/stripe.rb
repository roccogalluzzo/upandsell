module Gateways::Stripe

  def self.pay(product, payer)
    Stripe.api_key = User.find(product.user_id).credit_card_token
    payment = Stripe::Charge.create(
      amount: payer[:new_price] || product.price.cents,
      currency: product.price_currency.upcase,
      card: payer[:token]
      )
    return {token: payment['id'], card_type: payment['card']['brand'].downcase,
     status: 'completed'}
   end

   def self.refund(token, amount, user_id)
    Stripe.api_key = User.find(user_id).credit_card_token
    ch = Stripe::Charge.retrieve(token)
    ch.refunds.create
  end
end