include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :product do
    user
    name "Dummy product"
    price 300
    sequence(:file_key) { |n| "uploads/temp/products/1/test#{n}.exe" }
    price_currency 'USD'
    before(:create) do |instance|
     Fog.mock!
     aws =  Rails.application.secrets.aws
     FOG.put_object(aws["bucket"], instance.file_key, "test")
   end
 end
end
