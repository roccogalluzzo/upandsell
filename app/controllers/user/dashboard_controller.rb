class User::DashboardController < User::BaseController

  def index
    if current_user.currency = 'usd'
      @currency = '$'
    elsif current_user.currency = 'gbp'
      @currency = '£'
    else
      @currency = '€'
    end
  end

  def onload_metrics
    products = current_user.products
    demo = false
    visits = Metric::Product.new(products).visits(1.days.ago, :hour).get
    sales = Metric::Product.new(products).sales(1.days.ago, :hour).exchange_to(current_user.currency.to_sym).get
    if sales[:sales] == 0
      js_data = demo_data(:day)
      demo = true
    else
      js_data = to_js(visits[:data].deep_merge(sales[:data]))
    end
    earnings = get_earnings(sales)

    render json: {demo: demo, graph_data: js_data, sales: sales[:sales], visits: visits[:visits], conversion_rate: conversion_rate(visits[:visits], sales[:sales]), earnings: earnings}
    end

  def metrics
    if params[:products] != '0'
      products = current_user.products.where(id: params[:products])
    else
      products = current_user.products
    end
    demo = false
    pd = :day
    if params[:period] == 'month'
      period = 30.days.ago
    elsif params[:period] == 'week'
      period = 7.days.ago
    else
      period = 1.days.ago
      pd = :hour
    end

    visits = Metric::Product.new(@products).visits(period, pd).get
    sales = Metric::Product.new(@products).sales(period, pd).exchange_to(current_user.currency.to_sym).get
    if  sales[:sales] == 0
      js_data = demo_data(params[:period].to_sym)
      demo = true
    else
      js_data = to_js(visits[:data].deep_merge(sales[:data]))
    end
    render json: {demo: true, graph_data: js_data, sales: sales[:sales],
      visits: visits[:visits], conversion_rate: conversion_rate(visits[:visits], sales[:sales])}
    end

    def demo_data(period)
      js_data = []
      if period == :day
        (1.days.ago.to_i .. Time.now.to_i).step(1.hour) do |date|
          js_data << {date: Time.at(date), sales: Random.rand(1000), earnings: Random.rand(2000), visits: Random.rand(4000)}
        end
      elsif period == :week
        (7.days.ago.to_i .. Time.now.to_i).step(1.day) do |date|
          js_data << {date: Time.at(date), sales: Random.rand(1000), earnings: Random.rand(2000), visits: Random.rand(4000)}
        end
      else
        (30.days.ago.to_i .. Time.now.to_i).step(1.day) do |date|
          js_data << {date: Time.at(date), sales: Random.rand(1000), earnings: Random.rand(2000), visits: Random.rand(4000)}
        end
      end
      js_data
    end
    def to_js(data)
      graph = []
      data.each do |day, values|
        graph << {day: day}.merge(values)
      end
      graph
    end
    private
    def get_earnings(sales, convert = true)
      earnings = {}
      earnings[:month] =  sales[:earnings]
      earnings[:week] = split_week(sales[:data])
      if  sales[:data][Time.zone.now.beginning_of_day]
        earnings[:today] =  sales[:data][Time.zone.now.beginning_of_day][:earnings]
      else
        earnings[:today] = 0
      end
      earnings.each {|k,v|
        if convert
        earnings[k] = Money.new(v, current_user.currency).cents
      end
        }
      earnings[:summary_data] = sales[:data]
      earnings
    end

    private
    def conversion_rate(visits, sales)
      return 0 if (visits == 0) || (sales == 0)
      ((sales.fdiv(visits)) * 100).round(2)
    end

    private
    def split_week(data)
      days = (7.days.ago..Time.zone.now.beginning_of_day)
      week = data.select {|k,v| days.cover?(k)}
      week.inject(0) do |sum, (k,v)|
        sum + v[:earnings]
      end
    end
  end
