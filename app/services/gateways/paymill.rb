module Gateways::Paymill

  def self.pay(product, payer)
    Paymill.api_key = product.user.credit_card_token
    payment = Paymill::Payment.create(token: payer[:token])

    pay = Paymill::Transaction.create(
      amount: payer[:new_price] || product.price.cents,
      currency: product.price_currency.upcase,
      payment: payment.id)
    return {token: pay.id, card_type: pay.payment['card_type'], status: 'completed'}

  rescue Paymill::APIError => e
    Rails.logger.error "Paymill Error: " + e.message
    false
  end

  def self.refund(token, amount, user_id)
    Paymill.api_key = User.find(user_id).credit_card_token
    refund = Paymill::Refund.create id: token, amount: amount
    return true if refund.status == 'refunded'

  rescue Paymill::APIError => e
    Rails.logger.error "Paymill Error: " + e.message
    false
  end
end
