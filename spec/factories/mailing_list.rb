include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :mailing_list do
    name "Mailing List 1"
    user_id 1

    transient do
      orders_count 5
    end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |ml, evaluator|
        create_list(:order, evaluator.orders_count, mailing_list: ml)
      end
    end

  end