include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :order do
    email "dddd@cldlf.com"
    amount_cents 300
    amount_base_cents 150
    amount_currency 'USD'
product
  end

  factory :order_yankee, parent: :order do
    price_currency 'USD'
  end

  factory :order_french, parent: :order do
    price_currency 'EUR'
  end

  factory :order_english, parent: :order do
    price_currency 'GBP'
  end
end