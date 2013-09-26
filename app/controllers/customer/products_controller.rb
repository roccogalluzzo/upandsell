class Customer::ProductsController < ApplicationController

 def index
  @products = Product.all
end

def new
  @product = Product.new
end

def create
  @product = Product.new(params[:product].permit(:name, :price, :description, :file, :thumb))

  @product.save

  redirect_to @product

end

def show
  @product = Product.find(params[:id])
end

def edit
  @product = Product.find(params[:id])

end

def update
  @product = Product.find(params[:id])
  if @product.update(params[:product].permit(:name, :price, :description, :file, :thumb))
    redirect_to @product
  else
    render 'edit'

  end
end
def destroy
  @product = Product.find(params[:id])
  @product.destroy
  redirect_to products_path
end
end
