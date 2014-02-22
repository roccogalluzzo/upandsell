require 'modules/base52'
class Customer::ProductsController < Customer::BaseController

 def index

  @products = Customer.find(current_customer.id).product
end

def new
  @product = Product.new
  respond_to do |format|
    format.html
  end
end

def upload_request
  id = SecureRandom.uuid
  name = sanitize_filename(params[:name])
  path = "uploads/products/#{Base52.encode(current_customer.id)}/#{id}/#{name}"
  file = AWS::S3.new.buckets["upandsell"].presigned_post(
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
  @product.customer_id = current_customer.id
  @product.uuid =  sanitize_filename(params[:product][:upload_uuid])
  @product.file_file_name =  sanitize_filename( params[:product][:filename])
  if @product.save
   if @product.update(slug: Base52.encode(@product.id))
    return redirect_to customer_products_path, notice: 'Product was created.'
  end
end
render 'new'
end

def edit
  @product = Product.find(params[:id])
  if not @product.customer_id == current_customer.id
    render :file => "public/401.html", :status => :unauthorized
  end
end

def update
  @product = Product.find(params[:id])
  if not @product.customer_id == current_customer.id
    return render :file => "public/401.html", :status => :unauthorized
  end
  @product.uuid =  sanitize_filename(params[:product][:upload_uuid])
  @product.file_file_name =   sanitize_filename(params[:product][:filename])
  f_params = params[:product].permit(:name, :price, :price_currency,
    :description, :thumb)
  @product.attributes = f_params


  if @product.save
     return redirect_to customer_products_path, notice: 'Product was edited.'
  end
  render 'edit'
end

def destroy
  @product = Product.find(params[:id])
  if not @product.customer_id == current_customer.id
    render :file => "public/401.html", :status => :unauthorized
  end
  if @product.destroy
   msg = { status: 'ok'}

  render json: msg
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

