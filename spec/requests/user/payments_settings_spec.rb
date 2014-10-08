require 'rails_helper'

describe "Payments Settings" do
 before :all do
   post 'users/sign_in',
   'user[email]' => USER.email, 'user[password]' => USER.password
 end

 describe "Paypal Connect" do

  subject { get paypal_integration_path}

  it "redirect to paypal connect url" do
    VCR.use_cassette('paypal_connect', record: :once) do
      expect(subject).not_to redirect_to(action: :edit)
    end
  end

  it "save paypal connect to db" do
    VCR.use_cassette('paypal_connect_complete') do
      action = get paypal_integration_callback_path,
      request_token: 'AAAAAAAZ6-lEF6DxKBwh', verification_code: 'M.TMIZXa61gEo6Qtm33xFA'
      expect( flash[:notice]).to match 'Gateway Connected'
    end
  end

  it "no save paypal connect to db" do
    VCR.use_cassette('paypal_connect_incomplete') do
      action = get paypal_integration_callback_path,
      request_token: 'AAAAZ6-lEF6DxKBwh', verification_code: 'M.TMIZXa61gEo6Qtm33xFA'

      expect( flash[:alert]).to match 'Error during'
    end
  end

end

describe "Paymill Connect" do

  it "save paymill connect to db" do

   action = get paymill_integration_callback_path, code: '6fdce604e4c7af00bf87925086c36a83d4f31b04'
   user = User.find USER.id
   expect(user.credit_card_token).to eq('mock_token')
 end

end


end
