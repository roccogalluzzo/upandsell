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
end
