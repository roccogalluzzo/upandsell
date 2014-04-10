source 'http://rubygems.org'

gem 'rails', '4.0.2'

#custom gems
gem 'devise'
gem 'paypal-sdk-adaptivepayments'
gem 'paypal-sdk-permissions'
gem 'paymill'
gem 'money-rails'
gem 'paperclip', github: 'thoughtbot/paperclip'
gem 'aws-sdk'
gem 'simple_form'
gem 'agent_orange'
gem 'eu_central_bank'
gem 'kaminari'
gem 'sidekiq'
gem 'remotipart', '~> 1.2'
#test gems
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'
  gem 'guard-rspec', require: false
end
group :test do
  gem 'faker'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'sqlite3'
  gem 'simplecov', '~> 0.7.1', require: false
end

# database gems
gem 'mysql2'
gem "redis", "~> 3.0.1"
gem "hiredis", "~> 0.4.5"

# Javscript gems
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'
# Css gems
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'sass-rails'
gem "bower-rails", "~> 0.7.0"
gem "font-awesome-rails"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Deployment
gem 'capistrano', group: :development
gem 'puma'
gem 'foreman'
