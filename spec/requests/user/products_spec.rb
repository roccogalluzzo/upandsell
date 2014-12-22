require 'rails_helper'

describe "Products" do
  before { skip }
 before :all do
   post 'users/sign_in',
   'user[email]' => USER.email, 'user[password]' => USER.password
 end

 describe "Add New Product" do
  let(:product) {{product: { name: 'produ', price: 400}}}

  context "valid data" do

   it "create a new product" do
    post '/user/products/files', {name: 'test.exe'}
    file_key = JSON(response.body)['key']
    FOG.put_object('upandsell-dev', file_key, 'test')
    product[:product]["file_key"] = file_key
    post '/user/products', product
    expect(response.status).to eq(200)
  end

  it "create a new product with preview image" do
    post '/user/products/files', {name: 'test2.exe'}
    file_key = JSON(response.body)['key']
    FOG.put_object('upandsell-dev', file_key, 'test')
    product[:product][:file_key] = file_key
    product[:product][:preview] = Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/test.png",
     "image/png")
    post '/user/products', product
    expect(response.status).to eq(200)
  end

end

context "invalid data" do

  it "not create a new product" do
    post '/user/products', product
    expect(response.status).to eq(422)
  end

end
end

describe "Edit a Product" do
  let(:product) {USER.products[0]}

  it "update product name" do
    put "/user/products/#{product.id}", {product: {name: 'ciao'}}
    expect(response.status).to eq(200)
  end

  it "update product file" do
    post '/user/products/files', {name: 'test5.exe'}
    file_key = JSON(response.body)['key']
    FOG.put_object('upandsell-dev', file_key, 'test')
    put "/user/products/#{product.id}", {product: {file_key: file_key}}
    expect(response.status).to eq(200)
  end
end

describe "Delete a Product" do

  it "delete a product" do
    product = create(:product)
    delete "/user/products/#{product.id}"
    expect(response.status).to eq(302)
  end
end

end
