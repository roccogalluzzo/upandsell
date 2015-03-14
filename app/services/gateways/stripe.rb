module Gateways::Stripe

  def self.pay(product, payer)
    return false unless product.user.credit_card_token
    Stripe.api_key = product.user.credit_card_token

    payment = Stripe::Charge.create(
      amount: payer[:new_price] || product.price.cents,
      currency: product.price_currency.upcase,
      card: payer[:token]
      )
    return {token: payment.id, card_type: payment.card.brand.downcase,
     status: 'completed'}

   rescue Stripe::StripeError => e
    Rails.logger.error "Stripe Error: " + e.message
    false
  end

  def self.refund(token, amount, user_id)
    Stripe.api_key = User.find(user_id).credit_card_token
    ch = Stripe::Charge.retrieve(token)
    return true if ch.refunds.create.id

  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe Error: " + e.message
    false
  end
end
