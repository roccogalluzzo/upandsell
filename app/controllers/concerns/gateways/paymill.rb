module Gateways::Paymill

  def self.pay(product, opts)


    Paymill.api_key = User.find(product.user_id).credit_card_token
    payment = Paymill::Payment.create(token: opts[:token])

    pay = Paymill::Transaction.create(
      amount: product.price,
      currency: product.currency.upcase,
      payment: payment.id,
      fee_amount: ((product.price * 4) / 100),
      fee_payment: payment.id)

    return {token: pay.id, card_type: pay.payment['card_type'], status: 'closed'}
  end

end