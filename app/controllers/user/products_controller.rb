require 'modules/base52'
class User::ProductsController < User::BaseController

 def index

  @products = User.find(current_user.id).products
end

def new
  @product = Product.new
  respond_to do |format|
    format.html
  end
end

def share
  @product = Product.find(params[:id])
  @tweet_url =  URI.escape(
    "https://twitter.com/intent/tweet?text=#{@product.name} #{product_slug_url(@product.slug)}")
  @facebook_url = URI.escape(
    "https://www.facebook.com/sharer/sharer.php?u=#{product_slug_url(@product.slug)}&title=#{@product.name}")
end

def metrics
  if params[:products] != '0'
  product_ids = current_user.products.where(id: params[:products]).ids
else
  product_ids = current_user.products.ids
end

  if params[:range] == '1'
    earnings = Metric::Products.new(product_ids).earnings_today
    sales = Metric::Products.new(product_ids).sales_today
    visits =  Metric::Products.new(product_ids).visits_today
  elsif params[:range] == '7'
   earnings = Metric::Products.new(product_ids).earnings_last 7.days
   sales = Metric::Products.new(product_ids).sales_last 7.days
   visits = Metric::Products.new(product_ids).visits_last 7.days
 elsif params[:range] == '30'
  earnings = Metric::Products.new(product_ids).earnings_last 30.days
     sales = Metric::Products.new(product_ids).sales_last 30.days
   visits = Metric::Products.new(product_ids).visits_last 30.days
end
render json: {earnings: [Money.new(earnings[0]).format(:symbol => false), earnings[1]], sales: sales, visits: visits}
end
def summary
 @products = User.find(current_user.id).products
 product_ids = @products.ids
 @visits = Metric::Products.new(product_ids).visits_last 30.days
 @sales = Metric::Products.new(product_ids).sales_last 30.days
 @earnings = Metric::Products.new(product_ids).earnings_last 30.days
 # TODO convert to account currency
 @earnings_total = Money.new(@earnings[0])
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


def create
  params.permit(:product)
  @product = Product.new(params[:product].permit(:name, :price, :price_currency,
   :description, :thumb))
  @product.user_id = current_user.id
  @product.uuid =  sanitize_filename(params[:product][:upload_uuid])
  @product.file_file_name =  sanitize_filename( params[:product][:filename])
  if @product.save
   if @product.update(slug: Base52.encode(@product.id))
    return redirect_to share_user_product_path(@product.id), notice: 'Product was created.'
  end
end
render 'new'
end

def edit
  @product = Product.find(params[:id])
  if not @product.user_id == current_user.id
    render :file => "public/401.html", :status => :unauthorized
  end
end

def update
  @product = Product.find(params[:id])
  if not @product.user_id == current_user.id
    return render :file => "public/401.html", :status => :unauthorized
  end
  @product.uuid =  sanitize_filename(params[:product][:upload_uuid])
  @product.file_file_name =   sanitize_filename(params[:product][:filename])
  f_params = params[:product].permit(:name, :price, :price_currency,
    :description, :thumb)
  @product.attributes = f_params


  if @product.save
   return redirect_to user_products_path, notice: 'Product was edited.'
 end
 render 'edit'
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
