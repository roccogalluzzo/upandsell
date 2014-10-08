redis = Rails.application.secrets.redis
redis_url = "redis://#{redis['host']}:#{redis['port']}/#{redis['db']}"

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url, namespace: 'sidekiq' }
end
Sidekiq.configure_client do |config|
  config.redis = { url: redis_url, namespace: 'sidekiq' }
end
