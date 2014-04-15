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
  earns = current_user.products.earnings(true)
    @earnings = {}
  @earnings[:month] =  earns[0]
  @earnings[:summary_data] = earns[1]
end

def users
@users = User.find_all
end

def products
@products = Product.find_all
end

def orders

end
end