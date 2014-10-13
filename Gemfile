source 'http://rubygems.org'

gem 'rails', '4.1.4'
gem 'sdoc', require: false

# user managment
gem 'devise'
gem "devise-async"

# vendor integrations
gem 'paypal-sdk-adaptivepayments'
gem 'paypal-sdk-permissions'
gem 'paymill'
gem 'stripe'
gem 'braintree'
gem 'aws-sdk'
gem 'omniauth-createsend'
gem 'omniauth-mailchimp'
gem 'createsend'
gem 'gibbon'
gem 'mandrill-api'

# server
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'puma'
gem 'foreman'

# database gems
gem 'mysql2'
gem "redis", "~> 3.0.1"
gem "hiredis", "~> 0.4.5"

# rails related
gem 'money-rails'
gem 'monetize'
gem 'simple_form'
gem 'agent_orange'
gem 'kaminari'
gem 'remotipart', '~> 1.2'
gem 'rack-affiliates'
gem 'carrierwave'
gem 'fog'
gem 'carrierwave_direct', git: 'https://github.com/Rodeoclash/carrierwave_direct'
gem 'mini_magick'
gem 'carrierwave-processing'
gem "exchange", "~> 1.2.0"
gem 'redcarpet'
gem 'maildown'
gem 'tabs', git: 'https://github.com/byterussian/tabs.git', branch: 'customization'
gem 'email_validator'
gem 'premailer-rails'
gem "paranoia", "~> 2.0"

# Javscript gems
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'
gem 'jquery-ui-rails'

# Css gems
gem "less-rails"
gem 'sass-rails', github: 'rails/sass-rails'
gem "bower-rails", "~> 0.7.0"
gem "font-awesome-rails"
gem 'entypo-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'
  gem 'guard-rspec', require: false
  gem 'fuubar'
  gem 'vcr'
end
group :test do
  gem 'faker'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'timecop'
  gem 'sqlite3'
  gem 'simplecov', '~> 0.7.1', require: false
end

group :development do
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1'
  gem "better_errors"
  gem 'pry-rails'
  gem 'guard-livereload', require: false
  gem 'rb-fsevent'
  gem 'quiet_assets'
  gem 'spring'
end
