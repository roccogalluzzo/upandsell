  module Gateways::Paypal
    include PayPal::SDK::AdaptivePayments

    def self.pay(product, payer)

      user = User.find(product.user_id)
      paypal = PayPal::SDK::AdaptivePayments.new
      req = paypal.BuildPay(
       actionType: 'CREATE',
       receiverList: {
        receiver: [{
          accountId:      user.paypal_email,
          amount:  product.price,
          }]},
          cancelUrl: payer[:cancel_url],
          returnUrl: payer[:return_url] +'&payKey=${payKey}',
          ipnNotificationUrl:
          if Rails.env.production?
           'https://upandsell.me/checkout/ipn'
         else
           'http://upandsell.ngrok.com/checkout/ipn'
         end,
         currencyCode: product.price_currency.upcase
         )

      pay = paypal.pay(req)
   return {token: pay.payKey, card_type: 'paypal', status: 'created'}
 end

 def self.connect_url(callback_url)
   api = PayPal::SDK::Permissions::API.new
   request_permissions = api.build_request_permissions({
    scope: ["REFUND", "ACCESS_BASIC_PERSONAL_DATA"],
    callback: callback_url })

   response = api.request_permissions(request_permissions)
   api.grant_permission_url(response)
 end

 def self.connect(user, token, verification_code)

  api = PayPal::SDK::Permissions::API.new
  get_access_token = api.build_get_access_token(
    token: token, verifier: verification_code)
  access = api.get_access_token(get_access_token)

  if access.success?
    s_api = PayPal::SDK::Permissions::API.new({
     token: access.token.to_s,
     token_secret: access.tokenSecret.to_s })

    payer_id_call = s_api.get_basic_personal_data({
      :attributeList => {
        :attribute => [ "https://www.paypal.com/webapps/auth/schema/payerID" ] } })
    payer_id = payer_id_call.response.personalData[0].personalDataValue.to_s
    response = user.connect_paypal(payer_id, access.token, access.token_secret)
  end

end

def refund(token)

end
end


