require 'simplecov'
if ENV["COVERAGE_REPORTS"]
  require 'simplecov-csv'
  SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
  SimpleCov.coverage_dir(ENV["COVERAGE_REPORTS"])
end

SimpleCov.start 'rails' do
  add_filter "/helpers/"
  add_group "Services", "app/services"
end

ENV["RAILS_ENV"] ||= 'test'

require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'billy/rspec'
require 'webmock/rspec'
require 'capybara/poltergeist'

WebMock::API.stub_request(:get, "http://openexchangerates.org/api/latest.json?app_id=ae2dfadfe001425caf71503cf97d8b99")
.to_return(File.new(Rails.root.join("spec/support/ex_rates.json")))

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
end
