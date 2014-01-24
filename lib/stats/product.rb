class Stats::Products
  include Stats
  def initialize(id)
    @redis = redis
    @id = id
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

    def today_visits
      day = current_day
      @redis.hget("product:#{@id}:views", day).to_i
    end

    def week_visits
      day = current_day
      sum = 0
      7.times do
       sum += redis.hget("product:#{@id}:views", day).to_i
       day = day - 1.days.to_i
     end
     sum
   end

   def month_visits
    day = current_day
    sum = 0
    30.times do
     sum += @redis.hget("product:#{@id}:views", day).to_i
     day = day - 1.days.to_i
   end
   sum
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
    def today_sales
      day = current_day
      @redis.hget("product:#{@id}:sales", day).to_i
    end

    def week_sales
      day = current_day
      sum = 0
      7.times do
       sum += redis.hget("product:#{@id}:sales", day).to_i
       day = day - 1.days.to_i
     end
     sum
   end

   def month_sales
    day = current_day
    sum = 0
    30.times do
     sum += @redis.hget("product:#{@id}:sales", day).to_i
     day = day - 1.days.to_i
   end
   sum
 end
end
