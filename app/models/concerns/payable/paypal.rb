module Payable::Paypal
  include PayPal::SDK::AdaptivePayments

  def self.pay(product, *args)
    cancel_url, return_url = args
    paypal = PayPal::SDK::AdaptivePayments.new
    req = paypal.BuildPay(
     actionType: 'CREATE',
     receiverList: {
      receiver: [
        {
          accountId: product.user.paypal_email,
          amount:    product.price,
          primary:   true
          },
          {

            email:   if Rails.env.production?
            'paypal@upandsell.me'
          else
            'paypal-facilitator@upandsell.me'
          end,
          amount: ((product.price * 4) / 100)
        }
      ]
      },
      cancelUrl: cancel_url,
      returnUrl: return_url +'&payKey=${payKey}',
      ipnNotificationUrl:
      if Rails.env.production?
       'https://upandsell.me/products/ipn'
     else
       'http://upandsell.ngrok.com/products/ipn'
     end,
     currencyCode: product.price_currency.upcase,
     feesPayer: 'PRIMARYRECEIVER'
     )

    paypal.pay(req)
  end

end