Billy.configure do |c|
  c.cache = true
  c.cache_request_headers = false
  c.ignore_params = ["http://www.google-analytics.com/__utm.gif"]
  c.path_blacklist = []
  c.merge_cached_responses_whitelist = []
  c.persist_cache = true
  c.non_successful_cache_disabled = true
  c.non_successful_error_level = :debug
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

Capybara.register_driver(:poltergeist) do |app|
  Capybara::Poltergeist::Driver.new app,
  js_errors: true,
  timeout: 180,
  phantomjs_logger: Puma::NullIO.new,
  logger: nil,
  phantomjs_options:
  [
    '--load-images=no',
    '--ignore-ssl-errors=yes'
  ]
end
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 10
