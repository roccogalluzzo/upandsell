module Payable::Paymill

  def self.pay(product, *args)
    token = args
    Paymill.api_key = product.user.credit_card_token

    payment = Paymill::Payment.create(token: token)

    return Paymill::Transaction.create(amount: product.price.cents,
     currency: product.price_currency.upcase, payment: payment.id,
     fee_amount: ((product.price * 4) / 100).cents,
     fee_payment: payment.id
     )
  end

end