require 'rails_helper'
require 'uri'
require 'cgi'

describe "Checkout Process" do
  describe "buy product with Paymill" do
    context "valid cc info" do

      it "process order" do
        create(:user)
        product = create(:product)
        VCR.use_cassette('payment_with_paymill') do
          order = {email: 'blabla@fffff.com', token: 'tok_a428697472ff0fd78f7a',
            product_id: product.id }
          post 'checkout/pay', order
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe "buy product with Paypal" do
    context "valid" do
      it "process order" do
        create(:user)
        VCR.use_cassette('payment_with_paypal') do
          order = {product_id: 2}
          post 'checkout/paypal', order
        end

        uri = URI.parse(JSON(response.body)['url'])
        uri_params = CGI.parse(uri.query)
        pay_key = uri_params['paykey'][0]
        VCR.use_cassette('payment_paypal_ipn', record: :new_episodes) do
          post 'checkout/ipn', {pay_key: pay_key, sender_email: 'mail@roccogalluzzo',
            status: 'completed'}
            get 'checkout/check_payment', payKey: pay_key
          end

          expect(response.body).to include("You are being")
        end
      end
    end
  end