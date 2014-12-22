require "rails_helper"

describe Product do
  before { skip }
  it "get file extension" do
    product = create(:product)
    expect(product.extension).to eq('exe')
  end

  it "get file nane" do
 product = create(:product)
    expect(product.file_name).to match('test')
  end

  it "get file download url" do
   product = create(:product)
   expect(product.url).to match "https://upandsell-dev.s3-eu-west-1.amazonaws.com/uploads/products/1/test"
 end

end
