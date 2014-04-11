module Paypal

  def setup_payment(amount, to, re)
   paypal = PayPal::SDK::AdaptivePayments.new
   req = paypal.BuildPay(
     actionType: 'CREATE',
     receiverList: {
      receiver: [
        {
          accountId: to,
          amount:    amount,
          primary:   true
          },
          {
            email:  'paypal@upandsell.me',
            amount: ((@product.price * 4) / 100).cents
          }
        ]
        },
        cancelUrl: product_url(id: @product.id, payment: 'failed'),
        returnUrl:  products_check_payment_url(id: @product.id) +'&payKey=${payKey}',
        ipnNotificationUrl:
        if Rails.env.production?
         'https://upandsell.me/products/ipn'
       else
         'http://upandsell.ngrok.com/products/ipn'
       end,
       currencyCode: @product.price_currency.upcase,
       feesPayer: 'PRIMARYRECEIVER'
       )
 end

end