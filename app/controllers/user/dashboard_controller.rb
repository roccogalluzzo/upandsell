class User::DashboardController < User::BaseController

  def index
    @products = current_user.products
    visits = Metric::Product.new(@products).visits(30.days.ago).get
    sales = Metric::Product.new(@products).sales(30.days.ago).exchange_to(current_user.currency.to_sym).get
    @visits = visits[:visits]
    @sales = sales[:sales]
    @conversion_rate = conversion_rate(@visits, @sales)
    @earnings = get_earnings(sales)
  end

  def metrics
    if params[:products] != '0'
      products = current_user.products.where(id: params[:products])
    else
      products = current_user.products
    end
    visits = Metric::Product.new(products).visits(30.days.ago).get
    sales = Metric::Product.new(products).sales(30.days.ago).exchange_to(current_user.currency.to_sym).get
    earnings = get_earnings(sales, false)
    render json: {earnings: earnings, sales: sales[:sales],
      visits: visits[:visits], conversion_rate: conversion_rate(visits[:visits], sales[:sales])}
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
      earnings.each {|k,v| earnings[k] = Money.new(v, current_user.currency)} if convert
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
