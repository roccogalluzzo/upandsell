module Payable::Paypal
  include PayPal::SDK::AdaptivePayments
  def pay(product, *args)
    paypal = PayPal::SDK::AdaptivePayments.new
    req = paypal.BuildPay(
     actionType: 'CREATE',
     receiverList: {
      receiver: [
        {
          accountId: product.user.paypal_email,
          amount:    product.price.cents,
          primary:   true
          },
          {
            email:  'paypal@upandsell.me',
            amount: ((product.price * 4) / 100).cents
          }
        ]
        },
        cancelUrl: product_url(id: product.id, payment: 'failed'),
        returnUrl:  products_check_payment_url(id: product.id) +'&payKey=${payKey}',
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