include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :subscription_invoice do
    user
    stripe_id 'stripe_id'
    stripe_customer_id 'stripe_customer_id'
    year '2015'
    sequence(:sequence_number) { |n| n }
 end
end
