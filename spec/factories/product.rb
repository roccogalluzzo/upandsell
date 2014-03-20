include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :product do
    name "Dummy product"
    file_file_name {fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.png'), 'image/png')}
    price 300
    price_currency 'USD'
    uuid {SecureRandom.uuid}
    user
  end
end