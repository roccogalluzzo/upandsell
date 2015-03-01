class User::ProductsController < User::BaseController

  def index
    @products = current_user.products.page(params[:page]).per(6)
  end

  def new
    unless current_user.subscribed?
      redirect_to user_root_path
    end
    @product = Product.new
    @product.price_currency = current_user.currency
    @new_product = true
  end

  def create
    unless current_user.subscribed?
      redirect_to root_path
    end
    product = current_user.products.build(product_params)
    product.description = Sanitize.fragment(product.description, Sanitize::Config::BASIC)
    if product.save
      response = {product: product}
      response["twitter_url"] = twitter_url(product.name, product.slug)
      response["facebook_url"] = facebook_url(product.name, product.slug)
      response["edit_url"] =  user_product_path(product.id)
      response["symbol"] = product.price.symbol
      response["slug_url"] = product_slug_url(product.slug)
      render json: response and return
    end
    render json: {errors: product.errors}, status: :unprocessable_entity
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
    product.description = Sanitize.fragment(product.description, Sanitize::Config::BASIC)
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
    render json: {}, status: :unprocessable_entity and return
  end

  def destroy
    product = Product.find(params[:id])
    is_owner?(product.user_id)
    product.destroy
    @id = params[:id]
    respond_to do |format|
      format.js {}
    end
  end

  def files
    if params[:provider] == 'dropbox'
      render json: Product.upload_from_url(params[:file][:name], params[:file][:link])
    else
      render json: Product.request(params[:name])
    end
  end

  def share
    @product = Product.find(params[:id])
    is_owner?(@product.user_id)
    @twitter =  twitter_url(@product.name, @product.slug)
    @facebook =  facebook_url(@product.name, @product.slug)
    @slug = product_slug_url(@product.slug)
    respond_to do |format|
    format.html { redirect_to root_path } #for my controller, i wanted it to be JS only
    format.js
  end
end

def toggle_published
  product = Product.find(params[:id])
  is_owner?(product.user_id)
  product.toggle(:published)
  if product.save
    render json: {}, status: :ok and return
  end
  render json: {}, status: :unprocessable_entity
end

private
def product_params
  params.require(:product).permit(:name, :file_key, :price, :price_currency,
   :description, :preview, :sales_limit)
end

private
def is_owner?(product_id)
  if product_id != current_user.id
    render file: "public/500.html", status: :unauthorized
  end
end

private
def facebook_url(name, slug)
  URI.escape(
    "https://www.facebook.com/sharer/sharer.php?u=#{product_slug_url(slug)}&title=#{name}")
end

private
def twitter_url(name, slug)
  URI.escape(
    "https://twitter.com/intent/tweet?text=#{name} #{product_slug_url(slug)}")
end

def twitter_url(name, slug)
  URI.escape(
    "https://twitter.com/intent/tweet?text=#{name} #{product_slug_url(slug)}")
end
end
