StripeMock.spawn_server

Billy.configure do |c|
  c.cache = false
  c.cache_request_headers = false
  c.ignore_params = ["http://www.google-analytics.com/__utm.gif"]
  c.path_blacklist = []
  c.merge_cached_responses_whitelist = []
  c.persist_cache = true
  c.non_successful_cache_disabled = false
  c.non_successful_error_level = :warn
  c.non_whitelisted_requests_disabled = false
  c.cache_path = 'spec/req_cache/'
end

Capybara.register_driver :pg_billy do |app|
 options = {
   js_errors: false,
   timeout: 180,
   phantomjs_logger: Puma::NullIO.new,
   logger: nil,
   inspector: true,
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

RSpec.configure do |config|
  config.around(:each, stripe: true) do |example|
    WebMock.allow_net_connect!
    @client = StripeMock.start_client
    Features::StripeHelpers.setup_stripe
    StripeMock.toggle_debug(true)
    example.run
    WebMock.disable_net_connect!
    @client.clear_server_data
    @client.close!
  end
end