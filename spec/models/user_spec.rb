require "spec_helper"

describe User do
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

 end
 describe "#earnings" do
  before do
    @user = create(:user_yankee)
  end
  it "should return earnings if orders are only in user currency" do
    @user = create(:user_yankee)
    expect(@user.products.earnings[0]).to eq(Money.new(600, 'USD'))
  end
  it "should return user currency if orders are in other currency " do
    @user = create(:user_french)
    expect(@user.products.earnings[0].currency).to eq(Money.new(600, 'EUR').currency)
  end

end
describe "#sales" do
  before do
   @user = create(:user_with_products_and_sales)
 end

 it "should return sales" do
  @user.products.sales.should equal(2)
end
it "should not count incopleted sales" do
  @user.products.last.orders.create(email: 'dadada',
    payment_type: 'paymill',
    payment_token: 'sfdfs',
    status: 'created',
    amount: 300,
    cc_type: 'kkjkj')
  @user.products.sales.should equal(2)
end

it "should not count refunded sales" do
  @user.products.last.orders.create(email: 'dadada',
    payment_type: 'paymill',
    payment_token: 'sfdfs',
    status: 'refunded',
    amount: 300,
    cc_type: 'kkjkj')
  @user.products.sales.should equal(2)
end
end
describe "#add_paypal_refund" do

  before do
    @user = create(:user)
    @email = "paypal@test.com"
    @token = "jfljfsajflsjf"
    @token_secret = "kflflsklfklasf"
    @user.add_paypal_refund(@email ,@token, @token_secret)
  end
  it "should save paypal id" do
    @user.paypal_email.should == @email
  end
  it "should save paypal token" do
    @user.paypal_token.should == @token
  end
  it "should save paypal secret token" do
    @user.paypal_token_secret.should == @token_secret
  end
  it "should set paypal payment option to active" do
    @user.paypal.should == true
  end
end

describe "#add_credit_card" do

  before do
    @user = create(:user)
    @token = 'aaaaa'
    @public_token = 'aaaa'
    @data = {"access_token" => @token, "public_key" => @public_token}
    @user.add_credit_card(@data)
  end
  it "should save gategay token" do
    @user.credit_card_token.should == @token
  end
  it "should save credit card public token" do
    @user.credit_card_public_token.should == @public_token
  end
  it "should save all data response" do
   @user.credit_card_response = @data
 end
 it "should set credit card payment option to active" do
  @user.credit_card.should == true
end
end

end