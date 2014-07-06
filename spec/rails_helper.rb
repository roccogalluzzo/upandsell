require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/helpers/"
end
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# omniauth mock
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:mailchimp] = {
  uid: 1337,
  provider: 'mailchimp',
  info: { name: 'Rocky' },
  credentials: {
    token: 'mock_token'
  }
}
OmniAuth.config.mock_auth[:paymill] = {
  uid: 1337,
  provider: 'mailchimp',
  info: { name: 'Rocky' },
  credentials: {
    token: 'mock_token'
  }
}

WebMock.disable_net_connect!(allow_localhost: true)

Fog.mock!
@aws =  Rails.configuration.aws
FOG = ::Fog::Storage.new(
 provider: 'AWS',
 aws_access_key_id: @aws["access_key_id"],
 aws_secret_access_key: @aws["secret_access_key"],
 region: 'eu-west-1'
 )
FOG.directories.create(key: @aws["bucket"])

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock

  c.allow_http_connections_when_no_cassette = true
end

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include ValidUserRequestHelper
  config.include FactoryGirl::Syntax::Methods
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    USER ||= FactoryGirl.create :user_with_products
  end

  config.around(:each) do |example|
    Redis.new(Upandsell::Application.config.redis).flushdb
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
