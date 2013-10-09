class Customer::ProductsController < Customer::BaseController

 def index
  @products = Customer.find(current_customer.id).product
end

def new
  @product = Product.new
end

def create
  @product = Product.new(params[:product].permit(:name, :price, :description, :file, :thumb))
  @product.customer_id = current_customer.id
  
  if @product.save
    redirect_to customer_products_path, notice: 'Product was created.' 
  else
    render :new 

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
