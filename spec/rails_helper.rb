require 'simplecov'
require 'simplecov-csv'
if ENV["COVERAGE_REPORTS"]
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


 Capybara.javascript_driver = :poltergeist

Capybara.default_wait_time = 15
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    debug: false,
    default_wait_time: 30,
    js_errors: true,
    inspector: true,
    phantomjs_options: ['--ignore-ssl-errors=yes', '--ssl-protocol=any'],
    timeout: 90})
end

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
