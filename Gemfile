source 'http://rubygems.org'

gem 'rails', '4.1.4'
gem 'spring', group: :development
gem 'puma'
gem 'sdoc', require: false

#custom gems
gem 'devise'
gem "devise-async"
gem 'paypal-sdk-adaptivepayments'
gem 'paypal-sdk-permissions'
gem 'paymill'
gem 'money-rails'
gem 'monetize'
gem 'aws-sdk'
gem 'simple_form'
gem 'agent_orange'
gem 'kaminari'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
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
gem 'omniauth-createsend'
gem 'omniauth-mailchimp'
gem 'tabs', git: 'https://github.com/byterussian/tabs.git',
branch: 'customization'

gem 'omniauth-paymill'
gem 'createsend'
gem 'gibbon'
gem 'mandrill-api'

#test gems
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
gem "less-rails"
gem 'sass-rails', github: 'rails/sass-rails'
gem "bower-rails", "~> 0.7.0"
gem "font-awesome-rails"

# Deployment
group :development do
  gem 'capistrano'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-sidekiq'
  gem 'capistrano-rvm'
  gem 'foreman'
  gem 'pry-rails'
  gem 'guard-livereload', require: false
  gem 'rb-fsevent'
end
