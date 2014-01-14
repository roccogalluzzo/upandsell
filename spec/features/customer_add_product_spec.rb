require 'spec_helper.rb'

feature 'Customer add a product' do

  background do
   login
   visit new_customer_product_path
 end
 scenario 'without upload product file' do
  #attach_file('product[file]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  fill_in 'product[name]', :with => 'test product'
  fill_in 'product[price]', :with => '25'
  attach_file('product[thumb]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  click_on 'Create Product'
  expect(page).to have_content("can't be blank")
end
scenario 'without product name' do
  attach_file('product[file]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  fill_in 'product[price]', :with => '25'
  attach_file('product[thumb]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  click_on 'Create Product'
  expect(page).to have_content("can't be blank")
end
scenario 'without price' do
  attach_file('product[file]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  fill_in 'product[name]', :with => 'test product'
  attach_file('product[thumb]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  fill_in 'product[price]', :with => ''
  click_on 'Create Product'
  expect(page).to have_content("can't be blank")
end
scenario 'without preview thumb' do
  attach_file('product[file]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  fill_in 'product[name]', :with => 'test product'
  fill_in 'product[price]', :with => '25'
  click_on 'Create Product'
  expect(page).to have_content("can't be blank")
end
scenario 'without description' do
  attach_file('product[file]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  fill_in 'product[name]', :with => 'test product'
  fill_in 'product[price]', :with => '25'
  attach_file('product[thumb]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  click_on 'Create Product'
  expect(page).to have_content("was created")
end
end
