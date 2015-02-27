class PaymentService
  def initialize(gateway)
    @gateway = ("Gateways::#{gateway.classify}").constantize
    @gateway_name = gateway
  end

  def pay(product, payer)
    payment = @gateway.pay(product, payer)
    return false unless payment

    order = Order.new(
      product_id: product.id, user_id: product.user_id,
      coupon_id: payer[:coupon_id] || nil,
      email: payer[:email] || 'placeholder@paypal.com',
      gateway: @gateway_name, gateway_token: payment[:token],
      amount: payer[:new_price] || product.price,
      amount_currency: product.price_currency,
      payment_details: { card: payment[:card_type] },
      status: payment[:status])

    return false unless order.save
    order
  end

  def refund(token, amount, user_id)
    @gateway.refund(token, amount, user_id)
  end
end
