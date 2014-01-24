source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'rails', '4.0.2'

#custom gems
gem 'devise'
gem 'paypal-sdk-adaptivepayments'
gem 'money-rails'
gem 'paperclip'
gem 'aws-sdk'
gem 'simple_form'

#test gems
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end
group :test do
  gem 'faker'
  gem 'capybara'
  gem 'selenium-webdriver'
end
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: [:development, :test]
gem 'mysql', group: :production

# Javscript gems
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'
# Css gems
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'sass-rails'
gem "twitter-bootstrap-rails"
gem "font-awesome-rails"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use Capistrano for deployment
 gem 'capistrano', group: :development
