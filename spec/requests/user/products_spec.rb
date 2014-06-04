require 'spec_helper'

describe "Products" do

  describe "Add New Product" do

    context "valid data" do

      it "create a new product" do
        create(:user)
        post

        VCR.use_cassette('payment_with_paymill') do

          order = {email: 'blabla@fffff.com', token: 'tok_792738b0cbb450fdf18e', product_id: 2}
          post 'checkout/pay', order
          expect(response.status).to eq(201)
        end
      end
    end
  end
end