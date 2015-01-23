FactoryGirl.define do
  factory :user do
    name Faker::Name.name
    email {Faker::Internet.email}
    password '12345678'
    password_confirmation '12345678'

    factory :active_user, parent: :user do
      legal_name Faker::Name.name
      tax_code '12345678'
      country 'IT'
      address Faker::Address.street_address
      zip_code '89040'
      city Faker::Address.city
      province Faker::Address.state_abbr

      last_4_digits '1111'
      subscription_active true
      subscription_end {1.month.from_now}
      cc_brand 'mastercard'
      plan_type 'monthly'
    end
  end
end