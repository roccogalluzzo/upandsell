require 'spec_helper'

describe "Checkout Process" do

  describe "buy product with Paymill" do

    context "valid cc info" do

      it "process order" do
        create(:user)
        VCR.use_cassette('product') do
          get 'checkout/pay_info', product_id: 2
            expect(response.status).to eq(200)
        end

        VCR.use_cassette('payment_with_paymill') do
          order = {email: 'blabla@fffff.com', token: 'tok_792738b0cbb450fdf18e', product_id: 2}
          post 'checkout/pay', order
          expect(response.status).to eq(201)
        end
      end
    end
  end
end