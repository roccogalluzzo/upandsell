if Rails.env == "production"
  Sidekiq.configure_server do |config|
    config.redis = { :url => 'redis://db.upandsell.me:6379', :namespace => 'sidekiq' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { :url => 'redis://db.upandsell.me:6379', :namespace => 'sidekiq' }
  end
end