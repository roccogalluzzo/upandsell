module Metric
  class Products
    include Stats

    def initialize(ids)
      @ids = ids
    end

    def visits_last(period = 30.days)
      get('views', @ids, period)
    end

    def sales_last(period = 30.days)
      get('sales', @ids, period)
    end
    def earnings_last(period = 30.days)
      get('earnings', @ids, period)
    end

    def earnings_today
      get_daily('earnings', @ids)
    end
  end
end
