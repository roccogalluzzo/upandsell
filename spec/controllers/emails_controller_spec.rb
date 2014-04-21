require 'spec_helper'

describe EmailsController do
  describe "GET #unsubscribe" do
    before do
      @user = create(:user)
    end
    it "should unsubscribe user from sales notifications" do
      @user.unsubscribe_token('sales')
      get :unsubscribe,  @user.unsubscribe_token('sales')
      (User.find @user.id).email_after_sale.should   equal false
    end
    it "don't unsubscribe user from sales notifications" do
      get :unsubscribe,  {user: @user.id, type: 'sales', signature: "fake"}
      (User.find @user.id).email_after_sale.should  equal true
    end
  end

  describe "GET #unsubscribe" do
    before do
      stub_request(:head, /https:\/\/upandsell-test.s3.amazonaws.com\/.*/)
      .to_return(headers: {"Content-Length" => "33",
        'Content-Type'=>'klk', 'Last-Modified'=>'Sat, 19 Apr 2014 17:10:31 GMT'})
      stub_request(:delete, /https:\/\/upandsell-test.s3.amazonaws.com\/.*/)
      .to_return(headers: {"Content-Length" => "0"})
      stub_request(:get, "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml").
      to_return(:body => File.new(EU_CENTRAL_BANK_CACHE), :status => 200)
      Money.default_bank.save_rates(EU_CENTRAL_BANK_CACHE)
      Money.default_bank.update_rates(EU_CENTRAL_BANK_CACHE)
      @order = create(:order)
      @order.update_attribute :email_subscription, true
    end
    it "should unsubscribe buyer from user updates" do
     get :unsubscribe_product_updates,  @order.unsubscribe_token
      (Order.find @order.id).email_subscription.should  equal false
   end
    it "should not unsubscribe buyer from user updates" do
     get :unsubscribe_product_updates,  {order: @order.id, signature: "fake"}
      (Order.find @order.id).email_subscription.should equal true
   end
 end
end
