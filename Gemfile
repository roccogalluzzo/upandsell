source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

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
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more:
# https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'sass-rails'
gem "twitter-bootstrap-rails"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use Capistrano for deployment
 gem 'capistrano', group: :development
