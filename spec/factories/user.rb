FactoryGirl.define do
  factory :user do
    name "Dummy user"
    email 'example@comc.com'
    password '12345678'
    password_confirmation '12345678'
  end
end