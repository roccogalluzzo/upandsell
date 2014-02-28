module Metric
  class Products
    include Stats
    @metrics =  [:visits, :sales, :earnings]
    def initialize(ids)
      @ids = ids
    end

    @metrics.each do |attr|
      define_method("#{attr}_today") { get_daily(attr, @ids) }
    end

    @metrics.each do |attr|
      define_method("#{attr}_last") { | period = 30.days |
        get(attr, @ids, period)
      }
    end

    @metrics.each do |attr|
      define_method("incr_#{attr}") { |by = 1, date = nil|
        increment(attr, @ids, by, date)
      }
    end

    @metrics.each do |attr|
      define_method("decr_#{attr}") { |by = 1, date = nil|
        decrement(attr, @ids, by, date)
      }
    end

  end
end
