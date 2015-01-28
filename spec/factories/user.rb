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

    factory :stripe_user, parent: :active_user do
      stripe_id 'cus_00000000000000'
    end

    factory :cc_user, parent: :user do
      credit_card true
      credit_card_gateway 'Stripe'
      credit_card_token 'token'
      credit_card_public_token 'public_token'
    end

    factory :paypal_user, parent: :user do
      paypal true
      paypal_email 'rocco@galluzzo.me'
      paypal_token 'token'
      paypal_token_secret 'public_token'
    end
  end
end