require 'rails_helper'

describe "Payments Settings" do
 before :all do
   post 'users/sign_in',
   'user[email]' => USER.email, 'user[password]' => USER.password
 end

 describe "Paypal Connect" do

  subject { get connect_user_settings_payments_path, gateway: 'paypal' }

  it "redirect to paypal connect url" do
    VCR.use_cassette('paypal_connect', record: :once) do
      expect(subject).not_to redirect_to(action: :edit)
    end
  end

  it "save paypal connect to db" do
    VCR.use_cassette('paypal_connect_complete') do
      action = get connect_callback_user_settings_payments_path, gateway: 'paypal',
      request_token: 'AAAAAAAZ6-lEF6DxKBwh', verification_code: 'M.TMIZXa61gEo6Qtm33xFA'
      expect( flash[:notice]).to match 'Gateway Connected'
    end
  end

  it "no save paypal connect to db" do
    VCR.use_cassette('paypal_connect_incomplete') do
      action = get connect_callback_user_settings_payments_path, gateway: 'paypal',
      request_token: 'AAAAZ6-lEF6DxKBwh', verification_code: 'M.TMIZXa61gEo6Qtm33xFA'

      expect( flash[:alert]).to match 'Error during'
    end
  end

end

describe "Paymill Connect" do

  subject { get connect_user_settings_payments_path, gateway: 'paymill' }

  it "redirect to paymill connect url" do
    VCR.use_cassette('paymill_connect', record: :once) do
      expect(subject).not_to redirect_to(action: :edit)
    end
  end

  it "save paymill connect to db" do
    VCR.use_cassette('paymill_connect_complete') do
     action = get connect_callback_user_settings_payments_path, gateway: 'paymill',
     code: '6fdce604e4c7af00bf87925086c36a83d4f31b04'
     expect( flash[:notice]).to match 'Gateway Connected'
   end
 end

end


end