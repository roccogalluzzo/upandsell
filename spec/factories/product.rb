include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :product do
    name "Dummy product"
    price 300
    file_file_name 'fsds'
    price_currency 'USD'
    uuid {SecureRandom.uuid}
    user
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