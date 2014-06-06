require 'rails_helper'
require 'uri'
require 'cgi'

describe "Products" do
 before :all do
   @user ||= FactoryGirl.create :user
   post 'users/sign_in',
   'user[email]' => @user.email, 'user[password]' => @user.password
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
    product[:product][:preview] = Rack::Test::UploadedFile.new("spec/fixtures/files/test.png",
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
end