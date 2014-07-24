include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :order do
    email "ddd@cldlf.com"
    amount_cents 300
    amount_base_cents 150
    amount_currency 'USD'
    status 'created'
    token 'tok_a428697472ff0fd78f7a'
    gateway 'paypal'
    user
    product
  end

  factory :order_completed, parent: :order do
    status 'completed'
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