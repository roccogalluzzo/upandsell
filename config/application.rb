require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Upandsell
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'UTC'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_mailer.preview_path = "#{Rails.root}/app/mailer_previews"
    config.currencies = [:usd, :eur, :gpb]
    config.beta = true
    config.default_currency = :eur
    config.assets.raise_runtime_errors = false
    config.autoload_paths += %W(#{config.root}/lib)
    config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.autoload_paths << Rails.root.join( 'app', 'services')
    config.autoload_paths << Rails.root.join( 'lib')
    config.i18n.enforce_available_locales = true
    config.middleware.use Rack::Affiliates
    #config.action_dispatch.default_headers = {  'X-Frame-Options' => 'GOFORIT' }
    config.to_prepare do
      DeviseController.respond_to :html, :json
    end
    config.generators do |g|
        g.test_framework :rspec, :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
        g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
end
end
