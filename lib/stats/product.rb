class Stats::Products
  include Stats
  def initialize(id)
    @redis = redis
    @id = id
  end

  def visits_last(period, mapped = false)
    days = period.to_i / 1.day
    date = (current_day - period).to_i
    timestamps = Array.new(days) do
      date = date + 1.days.to_i
      date
    end
    visits = @redis.hmget("product:#{@id}:views", timestamps)
    visits.map!(&:to_i)
    total = visits.compact.inject(:+)
    if mapped
     return [total, Hash[timestamps.zip(visits)]]
   end
   return total
 end

 def visits(period)
  date = period.beginning_of_day.to_i
  total = @redis.hget("product:#{@id}:views", date).to_i
end

def add_visit
    #TODO add is human check
      #increment hour counter
      hour = current_hour
      @redis.hincrby("product:#{@id}:views:daily", hour, 1)
      #increment day counter
      day = current_day
      @redis.hincrby("product:#{@id}:views", day, 1)
    end

    def add_sale
      #increment hour counter
      hour = current_hour
      @redis.hincrby("product:#{@id}:salses:daily", hour, 1)
      #increment day counter
      day = current_day
      @redis.hincrby("product:#{@id}:sales", day, 1)
    end
    def remove_sale
      #increment hour counter
      hour = current_hour
      @redis.hincrby("product:#{@id}:salses:daily", hour, -1)
      #increment day counter
      day = current_day
      @redis.hincrby("product:#{@id}:sales", day, -1)
    end

    def sales_last(period)
      days = period.to_i / 1.day
      date = (current_day - period).to_i
      timestamps = Array.new(days) do
        date = date + 1.days.to_i
        date
      end
      sales = @redis.hmget("product:#{@id}:sales", timestamps)
      sales.map!(&:to_i)
      total = sales.compact.inject(:+)
     return total
   end
  end
