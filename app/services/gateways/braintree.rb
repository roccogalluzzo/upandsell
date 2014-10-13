module Gateways::Braintree

  def self.pay(product, payer)
    Braintree::Configuration.private_key = User.find(product.user_id).credit_card_token
    payment = Braintree::Transaction.submit_for_settlement(payer[:token])
    if payment.success?
      return {token: payment.id, card_type: payment['card']['brand'].downcase,
       status: 'completed'}
     end
     return false
   end

   def self.refund(token, amount, user_id)
     Braintree::Configuration.private_key  = User.find(product.user_id).credit_card_token
     ch = Stripe::Charge.retrieve(token)
     ch.refunds.create
   end
 end