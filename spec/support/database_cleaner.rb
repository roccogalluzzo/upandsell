  RSpec.configure do |config|
    config.around(:each) do |example|
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
      example.run
      DatabaseCleaner.clean
      Redis.new(Upandsell::Application.config.redis).flushdb
      Capybara.reset_sessions!
    end
    config.before :all do
      ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
    end
  end