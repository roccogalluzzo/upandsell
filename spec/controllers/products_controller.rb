require 'spec_helper'

describe ProductsController do
  before(:all) do
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

  let(:product) {create(:product)}

  describe "#pay_info" do

    it "should return success if valid product" do
      get :pay_info, product_id: product.id
      expect(response.status).to eq(200)
    end

    it "should return error if not valid product" do
      get :pay_info, product_id: 888
      expect(response.status).to eq(404)
    end
  end
  describe "#pay"
  describe "#paypal"
  describe "#download"
  describe "#show"
  describe "#ipn"
end