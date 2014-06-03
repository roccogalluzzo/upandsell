class User::ProductsController < User::BaseController

  def index
    @products = current_user.products.page(params[:page]).per(7)
  end

  def new
    @product = Product.new
    @product.price_currency = current_user.currency
    @new_product = true
  end

  def create
    product = current_user.products.build(product_params)

    if product.save
     response = {product: product}
     response["twitter_url"] = twitter_url(product.name, product.slug)
     response["facebook_url"] = facebook_url(product.name, product.slug)
     response["edit_url"] =  user_product_path(product.id)
     response["symbol"] = product.price.symbol
     response["slug_url"] = product_slug_url(product.slug)
     render json: response and return
   end
   render json: {}, status: :unprocessable_entity
 end

 def edit
  @product = Product.find(params[:id])
  is_owner?(@product.user_id)
  @twitter_url =  twitter_url(@product.name, @product.slug)
  @facebook_url =  facebook_url(@product.name, @product.slug)
  @slug = product_slug_url(@product.slug)
end

def update
  product = Product.find(params[:id])
  is_owner?(product.user_id)
  product.attributes = product_params
  #  price_currency:  @product.price.symbol }}
  if product.save
    response = {product: product}
    response["twitter_url"] = twitter_url(product.name, product.slug)
    response["facebook_url"] = facebook_url(product.name, product.slug)
    response["edit_url"] =  user_product_path(product.id)
    response["symbol"] = product.price.symbol
     response["slug_url"] = product_slug_url(product.slug)
    render json: response and return
  end
  render json: {}, status: :unprocessable_entity
end

def destroy
  product = Product.find(params[:id])
  is_owner?(product.user_id)
  if product.destroy
    return redirect_to user_products_path, notice: 'Product was deleted.'
  end
end

def upload_request
  render json: Product.request(params[:name])
end

def toggle_published
  product = Product.find(params[:id])
  is_owner?(product.user_id)
  product.toggle(:published)
  action = product.published ? "Unpublish" : "Publish"
  with = product.published ? "Unpublishing..." : "Publishing..."
  if product.save
    render json: {status: 200, action: action, with: with}
  else
    render json: {status: 500, action: action}
  end
end

def metrics
  if params[:products] != '0'
    products = current_user.products.where(id: params[:products])
  else
    products = current_user.products
  end

  visits = (Metric::Products.new(products.ids).visits_last 30.days)[0]
  sales = products.sales

  if visits > 0 and  sales > 0
   conversion_rate = ((sales.fdiv(visits)) * 100).round(2)
 else
  conversion_rate = 0
end
earns = products.earnings
earnings = {}
earnings[:month] =  earns[0].cents
earnings[:summary_data] = earns[1]
earnings[:week] =  Money.new(split_week(earns[1]), current_user.currency).cents
earnings[:today] = Money.new(earns[1][Date.today.to_time.to_i], current_user.currency).cents

render json: {earnings: earnings, sales: sales,
  visits: visits, conversion_rate: conversion_rate}
end

def summary
  @products = current_user.products
  @visits = (Metric::Products.new(current_user.products.ids).visits_last 30.days)[0]
  @sales = current_user.products.sales

  if @visits > 0 and  @sales > 0
   @conversion_rate = ((@sales.fdiv(@visits)) * 100).round(2)
 else
  @conversion_rate = 0
end

earns = current_user.products.earnings
@earnings = {}
@earnings[:month] =  earns[0]
@earnings[:summary_data] = earns[1]
@earnings[:week] =  Money.new(split_week(earns[1]), current_user.currency)
@earnings[:today] = Money.new(earns[1][Date.today.to_time.to_i], current_user.currency)
end

private
def product_params
  params.require(:product).permit(:name, :file_key, :price, :price_currency,
   :description, :preview)
end

private
def is_owner?(product_id)
  if product_id != current_user.id
    render file: "public/500.html", status: :unauthorized
  end
end

private
def twitter_url(name, slug)
  URI.escape(
    "https://www.facebook.com/sharer/sharer.php?u=#{product_slug_url(slug)}&title=#{name}")
end

private
def facebook_url(name, slug)
  URI.escape(
    "https://twitter.com/intent/tweet?text=#{name} #{product_slug_url(slug)}")
end

private
def split_week(data)
  today = Date.today
  days = (today.at_beginning_of_week..today.at_end_of_week)
  .map.each { |day| day.to_time.to_i }
  d_data = data.clone
  d_data.extract!(*days)
  .reduce(0) {|t,i| t + i[1]}
end
end
