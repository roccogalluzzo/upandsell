module Gateways::Braintree

  def self.pay(product, payer)
    user = User.find(product.user_id)
    if Rails.env.production?
      Braintree::Configuration.environment = :live
    else
      Braintree::Configuration.environment = :sandbox
    end
    Braintree::Configuration.merchant_id = user.credit_card_bt_merchant_id
    Braintree::Configuration.public_key = user.credit_card_public_token
    Braintree::Configuration.private_key = user.credit_card_token

    result = Braintree::Transaction.sale(
      amount:  product.price,
      payment_method_nonce: payer[:token])
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
     return false
   end

   def self.refund(token, amount, user_id)
    user = User.find(user_id)
    if Rails.env.production?
      Braintree::Configuration.environment = :live
    else
      Braintree::Configuration.environment = :sandbox
    end
    Braintree::Configuration.merchant_id = "tmnv8986bpp2tqnq"
    Braintree::Configuration.public_key = user.credit_card_public_token
    Braintree::Configuration.private_key = user.credit_card_token

    transaction = Braintree::Transaction.find(token)
    if transaction.status == "submitted_for_settlement"
      Braintree::Transaction.void(token).success?
    elsif transaction.status == "settled"
      Braintree::Transaction.refund(token).success?
    end
  end
end