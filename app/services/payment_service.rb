class PaymentService

  def initialize(gateway)
    @gateway = ("Gateways::#{gateway.classify}").constantize
    @gateway_name = gateway
  end

  def pay(product, payer)
   payment = @gateway.pay(product, payer)
   unless payment
     return false
   end
   order = Order.new(
    product_id: product.id,
    user_id: product.user_id,
    email: payer[:email] || 'placeholder@paypal.com',
    gateway: @gateway_name,
    gateway_token: payment[:token],
    amount: product.price,
    amount_currency: product.price_currency,
    payment_details: {card: payment[:card_type]},
    status: payment[:status])

   if !order.save
     return false
   end
   order
 end

 def refund(token, amount, user_id)
  @gateway.refund(token, amount, user_id)
end
end