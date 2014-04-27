class User::ProductsController < User::BaseController
  include S3Service

  def index
    @products = User.find(current_user.id).products.page(params[:page]).per(7)
  end

  def new
    @product = Product.new
    @product.price_currency = current_user.currency
    respond_to do |format|
      format.html
    end

  end

  def toggle_published
    product = Product.find(params[:id])
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

def upload_request
  name = sanitize_filename(params[:name])
  file = S3Service.upload(name)
  render json: { status: 'ok', id: file[:id], filename: name, fields: file[:fields]}
end

def file_changed
  product = Product.find(params[:id])

  if not product.user_id == current_user.id
    return render json: {status: 401}
  end

  product.uuid =  sanitize_filename(params[:new_uuid])
  product.file_file_name =   sanitize_filename(params[:filename])
  S3Service.upload_confirm(product.uuid, product.file_file_name)
  if product.save
   render json: {status: '200'}
 end
end

def create
  params.permit(:product)
  @product = Product.new(params[:product].permit(:name, :price, :price_currency,
   :description, :thumb))
  @product.published = true
  @product.user_id = current_user.id
  @product.uuid =  sanitize_filename(params[:product][:upload_uuid])
  @product.file_file_name =  sanitize_filename( params[:product][:filename])

  S3Service.upload_confirm(@product.uuid, @product.file_file_name)

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
    @twitter_url =  URI.escape(
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
    product = Product.find(params[:id])
    if not product.user_id == current_user.id
      render :file => "public/401.html", :status => :unauthorized
    end
    if product.destroy
      return redirect_to user_products_path, notice: 'Product was deleted.'
    end
  end
  private
  def sanitize_filename(filename)
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
    return fn.join '.'
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
