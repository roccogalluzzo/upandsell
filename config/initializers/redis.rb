REDIS_CONFIG =  YAML.load_file(Rails.root.join("config/redis.yml")).symbolize_keys
Upandsell::Application.config.redis =  REDIS_CONFIG[Rails.env.to_sym]
if Rails.env == "test"
Redis.new(Upandsell::Application.config.redis).flushdb
end
