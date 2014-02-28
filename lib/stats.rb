module Stats
  def redis
    @@redis ||= Redis.new(Upandsell::Application.config.redis)
  end

  def increment(metric, id, value = 1, date = nil)
    hour = date ? date.beginning_of_hour.to_time.to_i : current_hour
    day = date ? date.beginning_of_day.to_time.to_i : current_day

    if !date or ( day == current_day)
       redis.hincrby("product:#{id}:#{metric}:daily", hour, value)
    end

      redis.hincrby("product:#{id}:#{metric}", day, value)
    end

    def decrement(metric, id, value = 1, date = nil)
      increment(metric, id, - value, date)
    end

    def get(metric, ids, period)
      timestamps = period_to_timestamp(period)
      data = {}
      total = 0
      [*ids].each do | id |
        response = redis.hmget("product:#{id}:#{metric}", timestamps).map!(&:to_i)
        total += response.compact.inject(:+)
        response = Hash[timestamps.zip(response)]
        data.merge!(response){|k, old, new_v| old + new_v}
      end
      return total, data
    end

    def get_daily(metric, ids)
     date = current_day - 2.hour.to_i
     timestamps = Array.new(24) do
      date = date + 1.hour.to_i
      date
    end
    data = {}
    total = 0
    [*ids].each do | id |
      response = redis.hmget("product:#{id}:#{metric}:daily", timestamps).map!(&:to_i)
      total += response.compact.inject(:+)
      response = Hash[timestamps.zip(response)]
      data.merge!(response){|k, old, new_v| old + new_v}
    end
    return total, data
  end

  def current_hour
    t = Time.current
    t.beginning_of_hour.to_time.to_i
  end

  def current_day
    t = Time.current
    t.beginning_of_day.to_time.to_i
  end

  def period_to_timestamp(period)
   days = period.to_i / 1.day
   date = (current_day - period).to_i
   timestamps = Array.new(days) do
    date = date + 1.days.to_i
    date
  end
end
end
