# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user =User.create(:name => "User1", :email => "rocco@galluzzo.me", :password => "sanandreas").save

10.times do |i|
  file_key = Product.request("file#{i}.png")
  Product.create(name: "Product ##{i}", description: "A product.",
    price_cents: 500,
    price_currency: 'USD',
    file_key: file_key[:key],
    user_id: 1).save
end

5.times do |i|
 Product.first.orders.create(
    token: "token ##{i}",
    email: "test#{i}@email.com",
    amount_cents: 500,
    amount_currency: 'USD',
    gateway: 'paypal',
    amount_base_cents: 500).save
end

5.times do |i|
  Product.find(2).orders.create(
    token: "token ##{i}",
    email: "test#{i+5}@email.com",
    amount_cents: 500,
    amount_currency: 'USD',
    gateway: 'mastercard',
    amount_base_cents: 500,
    status: 'completed',
    user_id: 1).save
end
