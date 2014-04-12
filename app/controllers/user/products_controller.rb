require 'modules/base52'
class User::ProductsController < User::BaseController

 def index


  @products = User.find(current_user.id).products.page(params[:page]).per(7)
end

def new
  @product = Product.new
  respond_to do |format|
    format.html
  end
end

def toggle_published
  product = Product.find(params[:id])
  product.toggle(:published)
  sleep 3
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
    product_ids = current_user.products.where(id: params[:products]).ids
  else
    product_ids = current_user.products.ids
  end

  earnings = {}
  earnings[:today] = Money.us_dollar(Metric::Products.new(product_ids).earnings_today[0])
  .exchange_to(current_user.currency).cents
  earnings[:week] = Money.us_dollar((Metric::Products.new(product_ids).earnings_last 7.days)[0])
  .exchange_to(current_user.currency).cents
  earns =  Metric::Products.new(product_ids).earnings_last 30.days
  earnings[:month] =  Money.us_dollar(earns[0]).exchange_to(current_user.currency).cents
  earnings[:summary_data] = {}
  earns[1].each do |time,earns|
    earnings[:summary_data][time] =  Money.us_dollar(earns).exchange_to(current_user.currency).cents
  end


  sales = Metric::Products.new(product_ids).sales_last 30.days
  visits = Metric::Products.new(product_ids).visits_last 30.days
  if visits[0] > 0 and  sales[0] > 0
   conversion_rate = visits[0] / sales[0]
 else
  conversion_rate = 0
end
render json: {earnings: earnings, sales: sales, visits: visits, conversion_rate: conversion_rate}
end

def summary
 @products = current_user.products
 product_ids = @products.ids
 @visits = (Metric::Products.new(product_ids).visits_last 30.days)[0]
 @sales = (Metric::Products.new(product_ids).sales_last 30.days)[0]
 if @visits > 0 and  @sales > 0
   @conversion_rate = @visits / @sales
 else
  @conversion_rate = 0
end
earns =  Metric::Products.new(product_ids).earnings_last 30.days
@earnings = {}
@earnings[:month] =  Money.us_dollar(earns[0]).exchange_to(current_user.currency)
@earnings[:summary_data] = {}
earns[1].each do |time,earns|
  @earnings[:summary_data][time] =  Money.us_dollar(earns).exchange_to(current_user.currency).cents
end
@earnings[:week] =  Money.us_dollar((Metric::Products.new(product_ids).earnings_last 7.days)[0])
.exchange_to(current_user.currency)
@earnings[:today] = Money.us_dollar((Metric::Products.new(product_ids).earnings_today)[0])
.exchange_to(current_user.currency)

end

def upload_request
  id = SecureRandom.uuid
  name = sanitize_filename(params[:name])
  path = "uploads/products/#{Base52.encode(current_user.id)}/#{id}/#{name}"
  file = AWS::S3.new.buckets[Rails.configuration.aws["bucket"]].presigned_post(
    key: path,
    success_action_redirect: '/',
    success_action_status: 201,
    metadata: {
      id: id,
      file_name: name})

  msg = { status: 'ok', id: id, filename: name, fields: file.fields}

  render json: msg
end

def file_changed
  product = Product.find(params[:id])
  if not product.user_id == current_user.id
    return render :file => "public/401.html", :status => :unauthorized
  end
  product.uuid =  sanitize_filename(params[:new_uuid])
  product.file_file_name =   sanitize_filename(params[:filename])


  if product.save
   render json: {status: '200'}
 end
end

def create
  params.permit(:product)
  @product = Product.new(params[:product].permit(:name, :price, :price_currency,
   :description, :thumb))
  @product.user_id = current_user.id
  @product.uuid =  sanitize_filename(params[:product][:upload_uuid])
  @product.file_file_name =  sanitize_filename( params[:product][:filename])
  if @product.save
    tweet_url =  URI.escape(
      "https://twitter.com/intent/tweet?text=#{@product.name} #{product_slug_url(@product.slug)}")
    facebook_url = URI.escape(
      "https://www.facebook.com/sharer/sharer.php?u=#{product_slug_url(@product.slug)}&title=#{@product.name}")
    msg = { status: 200, product: {name: @product.name,
      preview: @product.thumb.url(:small), price_cents: @product.price_cents,
      price_currency:  @product.price.symbol, twitter_url: tweet_url, facebook_url: facebook_url,
      slug: product_slug_url(@product.slug), edit_url: user_product_path(@product) }}
    end
    render json: msg
  end

  def edit
    @product = Product.find(params[:id])
    @tweet_url =  URI.escape(
      "https://twitter.com/intent/tweet?text=#{@product.name} #{product_slug_url(@product.slug)}")
    @facebook_url = URI.escape(
      "https://www.facebook.com/sharer/sharer.php?u=#{product_slug_url(@product.slug)}&title=#{@product.name}")
    @slug = product_slug_url(@product.slug)
    if not @product.user_id == current_user.id
      render :file => "public/401.html", :status => :unauthorized
    end
  end

  def update
    @product = Product.find(params[:id])
    if not @product.user_id == current_user.id
      status = 401
    end
    @product.uuid =  sanitize_filename(params[:product][:upload_uuid])
    @product.file_file_name =   sanitize_filename(params[:product][:filename])
    f_params = params[:product].permit(:name, :price, :price_currency,
      :description, :thumb)
    @product.attributes = f_params

    if @product.save
     render json: { status: 201, product: {name: @product.name,
      preview: @product.thumb.url(:small), price_cents: @product.price_cents,
      price_currency:  @product.price.symbol }}
      return
    else
      status = 500
    end
    render json: {status: status}
  end

  def destroy
    @product = Product.find(params[:id])
    if not @product.user_id == current_user.id
      render :file => "public/401.html", :status => :unauthorized
    end
    if @product.destroy
      return redirect_to user_products_path, notice: 'Product was deleted.'
    end
  end
  private
  def sanitize_filename(filename)
  # Split the name when finding a period which is preceded by some
  # character, and is followed by some character other than a period,
  # if there is no following period that is followed by something
  # other than a period (yeah, confusing, I know)
  fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

  # We now have one or two parts (depending on whether we could find
  # a suitable period). For each of these parts, replace any unwanted
  # sequence of characters with an underscore
  fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

  # Finally, join the parts with a period and return the result
  return fn.join '.'
end
end
