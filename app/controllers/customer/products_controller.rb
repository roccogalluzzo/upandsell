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
    unless params[:product][:upload_id].blank?
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
  path = File.join(Rails.root.join('app', 'tmp_uploads').to_s, params[:product][:upload_id])
  @product.file =  File.new(path, "r")
  
  if @product.save
     File.delete(path)
    redirect_to customer_products_path, notice: 'Product was created.' 
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
  if @product.update(params[:product].permit(:name, :price, :description, :file, :thumb))
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
