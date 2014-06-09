redis =  YAML.load_file(Rails.root.join("config/redis.yml")).symbolize_keys
config = Exchange::Configuration.new do |c|
  c.implicit_conversions = false
  c.cache = {
    subclass: :redis,
    host:     redis[Rails.env.to_sym][:host],
    expire: :daily
  }

  c.api = {
    subclass: :xavier_media,
    retries: 3,
    protocol: :http,
    fallback: :ecb
  }
end

Exchange.configuration = config