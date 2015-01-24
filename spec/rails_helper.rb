require 'simplecov'
if ENV["COVERAGE_REPORTS"]
  require 'simplecov-csv'
  SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
  SimpleCov.coverage_dir(ENV["COVERAGE_REPORTS"])
end

SimpleCov.start 'rails' do
  add_filter "/helpers/"
end

ENV["RAILS_ENV"] ||= 'test'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'webmock/rspec'
require 'sidekiq/testing'
require 'capybara/poltergeist'
require 'thin'
require 'stripe_mock'
require 'billy/rspec'

StripeMock.spawn_server

Billy.configure do |c|
  c.cache = true
  c.cache_request_headers = false
  c.ignore_params = ["http://www.google-analytics.com/__utm.gif",
   "https://r.twimg.com/jot",
   "http://p.twitter.com/t.gif",
   "http://p.twitter.com/f.gif",
   "http://www.facebook.com/plugins/like.php",
   "https://www.facebook.com/dialog/oauth",
   "http://cdn.api.twitter.com/1/urls/count.json"]
   c.path_blacklist = []
   c.merge_cached_responses_whitelist = []
   c.persist_cache = false
  c.ignore_cache_port = true # defaults to true
  c.non_successful_cache_disabled = false
  c.non_successful_error_level = :warn
  c.non_whitelisted_requests_disabled = false
  c.cache_path = 'spec/req_cache/',
  c.dynamic_jsonp = true
  c.dynamic_jsonp_keys = ["callback"]
end

Capybara.register_driver :pg_billy do |app|
 options = {
   js_errors: false,
   timeout: 180,
   phantomjs_logger: Puma::NullIO.new,
   logger: nil,
   phantomjs_options:
   [
    '--load-images=no',
    '--ignore-ssl-errors=yes',
    "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
  ]
}
Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.javascript_driver = :pg_billy
Capybara.default_wait_time = 10

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }


WebMock.disable_net_connect!(allow_localhost: true)
aws =  Rails.application.secrets.aws
connection = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => aws["access_key_id"],
  :aws_secret_access_key    => aws["secret_access_key"]
  })

connection.directories.create(key: aws["bucket"])
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock

  c.allow_http_connections_when_no_cassette = true
end

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.before :all do
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
  end

  config.before(:each) do | example |
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all

    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    elsif example.metadata[:type] == :acceptance
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
    Redis.new(Upandsell::Application.config.redis).flushdb
    Capybara.reset_sessions!
  end

  config.around(:each, stripe: true) do |example|
    @client = StripeMock.start_client
    Features::StripeHelpers.setup_stripe
    example.run
    @client.clear_server_data
    @client.close!
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
