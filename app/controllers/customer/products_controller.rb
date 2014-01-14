require 'modules/base52'
class Customer::ProductsController < Customer::BaseController

 def index
  @products = Customer.find(current_customer.id).product
end

def new
  @product = Product.new
end

def upload

  # check if file size is more of 2GB
  if params[:product][:file] and (params[:product][:file].size < 2147483648)

    name = request.uuid #+ '---' + params[:product][:file].original_filename
    directory = Rails.root.join('app', 'tmp_uploads').to_s
    path = File.join(directory, name)
    File.open(path, "wb") { |f|
      f.write(params[:product][:file].read)
      f.chmod(0600)
    }

    unless params[:product][:upload_id].blank? or (params[:product][:upload_id] == '1')
      File.delete(File.join(directory, params[:product][:upload_id]))
    end
    msg = { status: 'ok', id: request.uuid}
  else
    # File superior to 2GB
    msg = { status: 'too_big'}
  end
  render json: msg
end

def create
  params.permit(:product)
  @product = Product.new(params[:product].permit(:name, :price, :description, :thumb))
  @product.customer_id = current_customer.id
  if params[:product][:file].present?
    @product.file = params[:product][:file]
  elsif params[:product][:upload_id].present?
    path = File.join(Rails.root.join('app', 'tmp_uploads').to_s, params[:product][:upload_id])
    @product.file =  File.new(path, "r")
    @product.file_file_name = params[:product][:upload_file_name]
  end
  if @product.save
   #generate slug
   #@product.slug =
   if @product.update(slug: Base52.encode(@product.id))
    unless params[:product][:upload_id].blank?
     File.delete(path)
   end
   redirect_to customer_products_path, notice: 'Product was created.'
 end
else
  print @product.errors.messages
  render :nothing => true
end
end

def show
  @product = Product.find(params[:id])
  if not @product.customer_id == current_customer.id
    render :file => "public/401.html", :status => :unauthorized
  end
end

def edit
  @product = Product.find(params[:id])
end

def update
  @product = Product.find(params[:id])
  if not @product.customer_id == current_customer.id
    render :file => "public/401.html", :status => :unauthorized
  end
  if not params[:product][:upload_id] == '1'
   path = File.join(Rails.root.join('app', 'tmp_uploads').to_s, params[:product][:upload_id])
   @product.file =  File.new(path, "r")
   @product.file_file_name = params[:product][:upload_file_name]
   File.delete(path)
 end

 if @product.update(params[:product].permit(:name, :price, :description, :thumb))

  redirect_to [:customer, @product]
else
  render 'edit'
end
end
def destroy
  @product = Product.find(params[:id])
  if not @product.customer_id == current_customer.id
    render :file => "public/401.html", :status => :unauthorized
  end
  @product.destroy
  redirect_to customer_products_path
end
end

