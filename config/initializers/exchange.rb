redis = Rails.application.secrets.redis
config = Exchange::Configuration.new do |c|
  c.implicit_conversions = false
  c.cache = {
    subclass: :redis,
    host:     redis['host'],
    expire: :daily
  }

  c.api = {
    :subclass => :open_exchange_rates,
    :app_id => "ae2dfadfe001425caf71503cf97d8b99",
    retries: 3,
    protocol: :http,
    fallback: :ecb
  }
end

Exchange.configuration = config