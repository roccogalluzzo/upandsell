include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :product do
    name "Dummy product"
    price 300
    sequence(:file_key) { |n| "uploads/temp/products/1/test#{n}.exe" }
    price_currency 'USD'
    user_id 1
    before(:create) do |instance|
     Fog.mock!
     @aws =  Rails.configuration.aws
     fog = ::Fog::Storage.new(
       provider: 'AWS',
       aws_access_key_id: @aws["access_key_id"],
       aws_secret_access_key: @aws["secret_access_key"],
       region: 'eu-west-1'
       )
     fog.put_object( 'upandsell-dev',
      instance.file_key, "test")
   end
 end

 factory :product_with_orders, parent: :product do

   ignore do
    orders 1
  end

  after(:create) do |product, evaluator|
    create_list(:order, evaluator.orders, product: product)
  end
end


factory :product_yankee, parent: :product do
  price_currency 'USD'
end

factory :product_french, parent: :product do
  price_currency 'EUR'
end

factory :product_english, parent: :product do
  price_currency 'GBP'
end


end