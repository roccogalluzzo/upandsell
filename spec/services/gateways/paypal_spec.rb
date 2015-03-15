require 'rails_helper'

describe Gateways::Paypal do

  describe '@pay' do
    let(:product) {build(:product)}
    before do
      @user = product.user
    end

    it 'should returns pay url' do
      @user.paypal_email = '2V7BJQA9VJTL8'
      @user.save
      VCR.use_cassette("service_paypal_pay") do
        response = Gateways::Paypal.pay(product, {
          return_url: 'http://ciao.com',
          cancel_url: 'http://ciao.com'})
        expect(response).to include(card_type: 'paypal',
          status: 'created',
          token: 'AP-9H684494TV209452C')
      end
    end
    it 'should returns false if account id is fake' do
      @user.paypal_email = '2VL8'
      @user.save
      VCR.use_cassette("service_paypal_pay_error") do
        response = Gateways::Paypal.pay(product, {
          return_url: 'http://ciao.com',
          cancel_url: 'http://ciao.com'})
        expect(response).to eq false
      end
    end
    it 'should returns false if no return url' do
      VCR.use_cassette("service_paypal_pay_error") do
        response = Gateways::Paypal.pay(product, {
          cancel_url: 'http://ciao.com'})
        expect(response).to eq false
      end
    end
  end

  describe '@connect_url' do
    it 'return connect url' do
      VCR.use_cassette("service_paypal_connect_url") do
        expect(Gateways::Paypal.connect_url('http://ciao.com'))
        .to eq 'https://www.sandbox.paypal.com/webscr?cmd=_grant-permission&request_token=AAAAAAAcsc9QqO5ikadm'
      end
    end
  end

  describe '@connect' do
    it 'generate connect tokens' do
      user = create(:user)
      token = 'AAAAAAAcrl.7mjcjpKjl'
      verification_code = 'H2Iew8OWbpaUS4AIql70Pw'
      VCR.use_cassette("service_paypal_connect") do
        expect(Gateways::Paypal.connect(user, token, verification_code)).to eq true
      end
    end
  end

  describe '@refund' do
    it 'refund a payment' do
      VCR.use_cassette("service_paypal_refund") do
        response = Gateways::Paypal.refund('AP-6S388162S0527214K', 5000, 1)
        expect(response).to eq true
      end
    end

    it 'not refund an already refunded payment' do
      VCR.use_cassette("service_paypal_refund_error") do
        response = Gateways::Paypal.refund('AP-6S388162S0527214K', 5000, 1)
        expect(response).to eq false
      end
    end
  end
end
