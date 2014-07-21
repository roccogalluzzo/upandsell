class Admin::AdminController < ApplicationController
  before_filter :authenticate_user!, :is_admin?
  layout 'admin'

  def is_admin?
    unless current_user.admin?
     redirect_to user_root_path
   end
 end

 def summary


  @users = User.count
  @users_today = User.where(
    created_at: (DateTime.now.at_beginning_of_day.utc..Time.now.utc)).count
  @products = Product.count
 @products_av = Product.group('price_currency').average('price_cents')
 @average_product_price = Money.new(@products_av["USD"])

 sales = Metric::Product.new(Product.all).sales(30.days.ago).get
 @earnings = get_earnings(sales)
end

def users
  @users = User.find_all
end

def products
  @products = Product.find_all
end

def orders

end

private
def split_week(data)
  days = (7.days.ago..Time.zone.now.beginning_of_day)
  week = data.select {|k,v| days.cover?(k)}
  week.inject(0) do |sum, (k,v)|
    sum + v[:earnings]
  end
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
end