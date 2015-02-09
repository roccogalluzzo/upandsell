redis = Rails.application.secrets.redis
config = Exchange::Configuration.new do |c|
  c.implicit_conversions = false
  c.cache = {
    subclass: :redis,
    host:     redis['host'],
    expire: :daily
  }

  c.api = {
    subclass: :ecb,
    retries: 3,
    protocol: :http,
    fallback: :ecb
  }
end

Exchange.configuration = config