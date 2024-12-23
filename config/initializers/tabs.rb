Tabs.configure do |config|

  # set it to an existing connection
  config.redis = Rails.application.secrets.redis

  # pass a prefix that will be used in addition to the "tabs" prefix with Redis keys
  # Example: "tabs:my_app:metric_name"
  config.prefix = "up_sell:metrics"

  config.negative_metric = false
  # override default decimal precision (5)
  # affects stat averages and task completion rate
  config.decimal_precision = 2

  # unregisters any resolution
  config.unregister_resolutions(:minute)

  # sets TTL for redis keys of specific resolutions
  config.set_expirations({ hour: 2.day })

end
