Tabs.configure do |config|

  # set it to an existing connection
  config.redis = Redis.current

  # pass a config hash that will be passed to Redis.new
  config.redis = { host: 'localhost', port: 6379, db: 2 }

  # pass a prefix that will be used in addition to the "tabs" prefix with Redis keys
  # Example: "tabs:my_app:metric_name"
  config.prefix = "up_sell:metrics"

  config.negative_metric = false
  # override default decimal precision (5)
  # affects stat averages and task completion rate
  config.decimal_precision = 2

  # unregisters any resolution
  config.unregister_resolutions(:minute, :hour)

  # sets TTL for redis keys of specific resolutions
  #config.set_expirations({ minute: 1.hour, hour: 1.day })

end