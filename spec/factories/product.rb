FactoryGirl.define do
  factory :product do
    user
    name "Dummy product"
    price 300
    sequence(:file_key) { |n| Product.request("test#{n}.exe")['key'] }
    price_currency 'USD'
    before(:create) do |instance|
     Fog.mock!
     aws =  Rails.application.secrets.aws
     FOG.put_object(aws["bucket"], instance.file_key, "test")
   end
 end
 factory :product_with_preview, parent: :product do
   preview 'preview.png'
 end
end
