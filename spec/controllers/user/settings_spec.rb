require 'spec_helper'
describe User::SettingsController do
  include Devise::TestHelpers
  describe 'GET #add_paypal' do
   context 'when not altredy connected' do
    it 'should redirect to paypal' do

           stub_request(:post, "https://svcs.sandbox.paypal.com/Permissions/RequestPermissions").
         with(:body => "{\"requestEnvelope\":{\"errorLanguage\":\"en_US\"},\"scope\":[\"REFUND\"],
          \"callback\":\"http://localhost:3000/user/settings/add_paypal_callback\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'X-Paypal-Application-Id'=>'APP-80W284485P519543T',
                 'X-Paypal-Request-Data-Format'=>'JSON',
                 'X-Paypal-Request-Source'=>'permissions-ruby-sdk-1.96.3',
                  'X-Paypal-Response-Data-Format'=>'JSON', '
                  X-Paypal-Sandbox-Email-Address'=>'mail-facilitator@roccogalluzzo.com',
                  'X-Paypal-Security-Password'=>'1380265896',
                  'X-Paypal-Security-Signature'=>'ACXOynAE4-4hmGxsXPS1TQ2mkkDIAkkcSXkACzxwx9jAOOKTEmzGvEFw',
               'X-Paypal-Security-Userid'=>'cicio_api1.galluzzo.me'})
      sign_in create(:user)
      get :add_paypal
    end
  end
end
end