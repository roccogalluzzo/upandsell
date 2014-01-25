module LibStats
  module Helpers
    def self.add_visit(id, period)
      include Stats
     current_day = Time.current.beginning_of_day.to_time.to_i
     day = (current_day - (period - 1.day)).to_i
     @@redis.hincrby("product:#{id}:views", day, 1)
   end
 end
end
