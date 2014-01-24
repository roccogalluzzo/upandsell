module Stats
  def redis
    @@redis ||= Redis.new(Upandsell::Application.config.redis)
  end

  def current_hour
    t = Time.new
    t.beginning_of_hour.to_time.to_i
  end

  def current_day
    t = Time.new
    t.beginning_of_day.to_time.to_i
  end

end
require 'stats/product'
