FactoryGirl.define do
  factory :user do
    name "John"
    sequence(:email) { |n| "person#{n}@byebye.com" }
    password '12345678'
    password_confirmation '12345678'
  end


  factory :user_with_products, parent: :user do
    ignore do
      products 2
    end

    after(:create) do |user, evaluator|
      create_list(:product, evaluator.products, user: user)
    end
  end
  factory :user_with_products_and_sales, parent: :user do
    ignore do
      products 2
    end

    after(:create) do |user, evaluator|
      create_list(:product_with_orders, evaluator.products, user: user)
    end
  end

  factory :user_yankee, parent: :user_with_products_and_sales do
    currency 'USD'
  end
    factory :user_french, parent: :user_with_products_and_sales do
    currency 'EUR'
  end
end