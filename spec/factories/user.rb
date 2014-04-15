FactoryGirl.define do
  factory :user do
    name "Dummy user"
    sequence(:email) { |n| "person#{n}@example.com" }
    password '12345678'
    password_confirmation '12345678'
  end

  factory :user_with_products, parent: :user do

    ignore do
      products_count 5
      type 'yankee'
    end

    after(:create) do |user, evaluator|
     product = :"product_#{evaluator.type}"
     create_list(product, evaluator.products_count, user: user)
   end
 end
 factory :yankee_with_products, parent: :user_with_products do
  currency 'USD'
end

factory :french_with_products, parent: :user_with_products do
  currency 'EUR'
end

factory :english_with_products, parent: :user_with_products do
  currency 'GBP'
end
end