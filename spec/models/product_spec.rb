require "rails_helper"

describe Product do

  let(:product) {create(:product)}
  it "get product file extension" do
    expect(product.extension).to eq('exe')
  end

  it "get product file nane" do
    expect(product.file_name).to match('test')
  end

  it "delete product file" do
    expect(product.delete_file).to eq true
  end

  it "get file size" do
    expect(product.file_size).to eq 4
  end

  it "get empty file size" do
    product.file_info = nil
    expect(product.file_size).to eq 0
  end

  it "get file download url" do
   expect(product.url)
   .to match /https:\/\/upandsell-s3-dev\.s3-eu-west-1\.amazonaws\.com\/uploads\/products.*/
 end

 describe '#upload_from_url' do
  it 'upload specified url' do
    VCR.use_cassette("service_upload_from_url", :record => :new_episodes) do
      expect(Product.upload_from_url('rails_logo.png', 'http://rubyonrails.org/images/rails.png')[:file_key])
      .to match 'uploads/temp/products/'
    end
  end
  it 'return fail if network error' do
    WebMock::API.stub_request(:get, "http://rubyonrails.org/images/rails.png")
    .to_return( :status => ['404', 'Not Found'])
    expect(Product.upload_from_url('rails_logo.png', 'http://rubyonrails.org/images/rails.png'))
    .to eq false
  end
end

end
