REDIS_CONFIG =  Rails.application.secrets.redis
Upandsell::Application.config.redis =  REDIS_CONFIG
if Rails.env == "test"
Redis.new(Upandsell::Application.config.redis).flushdb
end
