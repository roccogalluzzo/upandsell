module Gateways::Paypal
  include PayPal::SDK::AdaptivePayments

  def self.pay(product, payer)
    return false unless product.user.paypal_email?
    return false unless payer[:cancel_url]
    return false unless payer[:return_url]

    paypal = PayPal::SDK::AdaptivePayments.new
    pay = paypal.pay(build_pay(product, payer))

    return false unless pay.success?
    return {token: pay.payKey, card_type: 'paypal', status: 'created'}
  end

  def self.connect_url(callback_url)
   api = PayPal::SDK::Permissions::API.new
   request_permissions = api.build_request_permissions({
    scope: ["REFUND", "ACCESS_BASIC_PERSONAL_DATA"],
    callback: callback_url })

   response = api.request_permissions(request_permissions)
   return false unless response.success?
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

def self.refund(token, amount, user_id)
  api = PayPal::SDK::AdaptivePayments::API.new
  refund = api.build_refund({payKey: token })
  api.refund(refund)
end

def self.build_pay(product, payer)
  paypal = PayPal::SDK::AdaptivePayments.new
  paypal.BuildPay(
   actionType: 'CREATE',
   receiverList: {
    receiver: [{
      accountId: product.user.paypal_email,
      amount: payer[:new_price] || product.price,
      }]},
      cancelUrl: payer[:cancel_url],
      returnUrl: payer[:return_url] +'&payKey=${payKey}',
      ipnNotificationUrl: ipn_url,
      currencyCode: product.price_currency.upcase
      )
end
def self.ipn_url
  return 'https://upandsell.me/checkout/ipn' if Rails.env.production?
  'http://upandsell.ngrok.com/checkout/ipn'
end
end
