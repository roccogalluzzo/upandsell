module Gateways::Paypal
  include PayPal::SDK::AdaptivePayments

  def self.pay(product, opts)

    user = User.find(product.user_id)
    paypal = PayPal::SDK::AdaptivePayments.new
    req = paypal.BuildPay(
     actionType: 'CREATE',
     receiverList: {
      receiver: [
        {
          email: 'mail@roccogalluzzo.com', #user.email,
          amount:    product.price,
          primary:   true
          },
          {
            email:
            if Rails.env.production?
              'paypal@upandsell.me'
            else
              'paypal-facilitator@upandsell.me'
            end,
            amount: ((product.price * 4) / 100)
          }
        ]
        },
        cancelUrl: opts[:cancel_url],
        returnUrl: opts[:return_url] +'&payKey=${payKey}',
        ipnNotificationUrl:
        if Rails.env.production?
         'https://upandsell.me/products/ipn'
       else
         'http://upandsell.ngrok.com/products/ipn'
       end,
       currencyCode: product.currency.upcase,
       feesPayer: 'PRIMARYRECEIVER'
       )

    pay = paypal.pay(req)
   # byebug
    return {token: pay.payKey, card_type: 'paypal', status: 'created'}
  end

end