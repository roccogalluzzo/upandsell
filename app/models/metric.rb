module Metric

  class Sales
    attr_accessor :data, :sales, :earnings

    def initialize(data = [])
      @app_currency = Upandsell::Application.config.default_currency
      if data.is_a?(Array)
       @data = {}
       @sales = 0
       @earnings = 0
     else
      @data = parse(data.values)
      @sales = data.count
      @earnings = data.sum
    end
  end

  def parse(data)
   t_data = {}
   data.each do |e|
    t_data[e['timestamp']] = { sales: e['count'], earnings: e['sum']}
  end
  t_data
end

def +(other)
  @sales += other.sales
  @earnings += other.earnings
  other.data.each do |day, d_data|
    if  @data[day].is_a?(Hash)
      @data[day].merge!(other.data[day]) {|k, o, n| o + n}
    else
     @data[day] = other.data[day]
   end
 end
 self
end

def get
  {data: @data, sales: @sales, earnings: @earnings}
end

def exchange_to(currency)
  return self if currency.downcase.to_sym == @app_currency
  c_earnings = 0
  @data.each do |day, d_data|
    new_earn = @data[day][:earnings].in(@app_currency).to(currency.downcase, at: day).to_i
    c_earnings += new_earn
    @data[day][:earnings] = new_earn
  end
  @earnings = c_earnings
  self
end
end

class Visits
  attr_accessor :data, :visits

  def initialize(data = [])
    if data.is_a?(Array)
     @data = {}
     @visits = 0
   else
    @data = parse(data.values)
    @visits = data.total
  end
end

def parse(data)
 t_data = {}
 data.each do |e|
  t_data[e['timestamp']] = e['count']
end
t_data
end

def +(other)
  @visits += other.visits
  other.data.each do |day, d_data|
    if  @data[day]
      @data[day] += other.data[day]
    else
     @data[day] = other.data[day]
   end
 end
 self
end

def get
  {data: @data, visits: @visits}
end
end

class Product

  def initialize(products)
    @products = *products
    @sales = Sales.new
    @visits = Visits.new
  end

  def sales(from = Time.now)
    @products.each { |p| @sales += sales_product(p.id, from) }
    @sales
  end

  def sales_product(id, from)
    r = Tabs.get_value_stats("product:#{id}:sales", from..Time.now, :day)
    Sales.new(r)
  end

  def visits(from = Time.now)
    @products.each { |p| @visits += visits_product(p.id, from) }
    @visits
  end

  def visits_product(id, from)
    r = Tabs.get_counter_stats("product:#{id}:visits", from..Time.now, :day)
    Visits.new(r)
  end

  def exchange_to(currency)

  end


  def record_sale(amount, date = Time.now)
   @products.each do |p|
    Tabs.record_value("product:#{p.id}:sales", amount, date)
  end
end

def delete_sale(amount, date = Time.now)
 @products.each do |p|
  Tabs.delete_value("product:#{p.id}:sales", amount, date)
end
end

def record_visit
  @products.each do |p|
    Tabs.increment_counter("product:#{p.id}:visits", Time.now)
  end
end
end
end
