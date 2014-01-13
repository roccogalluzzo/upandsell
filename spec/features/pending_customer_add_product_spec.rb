require 'spec_helper.rb'

feature 'Customer add a product' do
 self.use_transactional_fixtures = false
 scenario 'without upload product file', :js => true do
  pending()
  login
  visit new_customer_product_path
  Capybara.default_wait_time = 10
  Capybara.ignore_hidden_elements = false
  attach_file('product[file]', Rails.root.join('spec','fixtures', 'files', 'test.png'))
  keypress_script = "$('input#my_field').val('some string').keydown();"
  page.driver.browser.execute_script(keypress_script)
  expect(page).to have_content('test.png')
end

end
