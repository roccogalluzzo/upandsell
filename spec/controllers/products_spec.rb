require 'spec_helper'
describe ProductsController do
  describe 'POST #pay' do

    context 'when payment info are valid' do
      it 'return success status' do
              stub_request(:head,
        /https:\/\/upandsell-test.s3.amazonaws.com\/uploads\/products\/.*/)
      .to_return(status: 200, body: "kk", headers: {
        'x-amz-meta-file_name' => 'test.png',
        'Content-Length' => '3456',
        'Content-Type' => 'text/plain',
        'Last-Modified' => 'Sun, 1 Jan 2006 12:00:00 GMT'
        })
      stub_request(:delete,
        /https:\/\/upandsell-test.s3.amazonaws.com\/uploads\/products\/.*/)
      .to_return(status: 204, body: "")

      stub_request(:post, /https:\/\/.*api.paymill.com\/v2\/payments/)
      .to_return(status: 204, body: '
        {"data" : {
          "id"           : "pay_3af44644dd6d25c820a8",
          "card_type"    : "visa",
          "created_at"   : 1349942085,
          "updated_at"   : 1349942085
          },
          "mode" : "test"
        }
        ')
      stub_request(:post, /https:\/\/.*api.paymill.com\/v2\/transactions/)
      .to_return(status: 204, body: '
        {
    "data" : {
        "id" : "tran_1f42e10cf14301067332",
        "amount" : "4200",
        "origin_amount" : 4200,
        "status" : "closed",
        "livemode" : false,
        "currency" : "EUR",
        "response_code" : 20000,
        "short_id" : "0000.1212.3434",
        "is_fraud" : false
    },
    "mode" : "test" }')
        product = create(:product)
        product.user.add_credit_card({'access_token' => 'fdsafsa', 'public_key' => 'ffjajfljl'})
        post :pay,  {product_id: product.id, token: '098f6bcd4621d373cade4e832627b4f6', email: 'ciao@ckalk.com'}
        JSON.parse(response.body)['status'].should  == 'completed'
      end
    end
  end
end