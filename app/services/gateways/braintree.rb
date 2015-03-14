module Gateways::Braintree

  def self.pay(product, payer)
    user = product.user
    setup_braintree_api(user)

    result = Braintree::Transaction.sale(
      amount:  payer[:new_price] || product.price,
      payment_method_nonce: payer[:token])
    return false unless result.transaction

    if result.transaction.currency_iso_code != product.price_currency.upcase
      Braintree::Transaction.void(result.transaction.id)
      return false
    end
    if result.success?
      payment = Braintree::Transaction.submit_for_settlement(result.transaction.id)
    end
    if payment.success?
      return {token: result.transaction.id, card_type: result.transaction.credit_card_details.card_type.downcase,
       status: 'completed'}
     end

   rescue ::Braintree::BraintreeError
     false
   end

   def self.refund(token, amount, user_id)
    user = User.find(user_id)
    setup_braintree_api(user)

    transaction = Braintree::Transaction.find(token)
    if transaction.status == "submitted_for_settlement"
      return Braintree::Transaction.void(token).success?
    elsif transaction.status == "settled"
      return Braintree::Transaction.refund(token).success?
    end
    false
  end

  def self.setup_braintree_api(user)
    Braintree::Configuration.merchant_id = user.credit_card_bt_merchant_id
    Braintree::Configuration.public_key = user.credit_card_public_token
    Braintree::Configuration.private_key = user.credit_card_token
  end
end