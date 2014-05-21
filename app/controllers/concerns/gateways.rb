module Gateways extend ActiveSupport::Concern


  def self.pay(product, gateway, opts)

   api = get_gateway(gateway)
   pay = api.pay(product, opts)

   order = Order.new(
    product_id: product.id,
    user_id: product.user_id,
    email: opts[:email] || 'placeholder@paypal.com',
    gateway: gateway,
    gateway_token: pay[:token],
    amount: product.price,
    currency: product.currency,
    payment_details: {card: pay[:card_type]},
    status: pay[:status])

   if !order.create
    return false
  end
  order
end

def self.get_gateway(name)
  ("Gateways::#{name.classify}").constantize
end
end