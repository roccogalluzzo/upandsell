require "spec_helper"

describe User do

 describe "#earnings"
 it "should return earnings if orders are only in user currency" do
  stub_request(:head, /https:\/\/upandsell-test.s3.amazonaws.com\/uploads\/products\/*/)
  .to_return(:status => 200, :headers => {'Content-Length' => 3,
   'Content-Type'=>'',
   'Last-Modified'=>'Tue, 15 Apr 2014 14:46:56 GMT' })
  stub_request(:delete, /https:\/\/upandsell-test.s3.amazonaws.com\/uploads\/products\/*/)
  .to_return(:status => 200)


  user = create(:french_with_products, type: 'french')

  user.products.last.orders.build(
      email: 'jkjkjkj',
      payment_type: 'paymill',
      payment_token: ';kk;k',
      status: 'completed',
      amount: 12).save
  user.products.earnings.cents.should == 300
  Rails.logger.info user
end

it "should return earnings if orders are in one currency but not in user currency"

it "should return earnings if orders are in multiple currency"

it "should return nil if no earnings"

end