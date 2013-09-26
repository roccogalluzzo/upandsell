class CustomersController < ApplicationController
  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(params[:customer].permit(:name, :email))

    @customer.save

    redirect_to @customer

  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])

  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(params[:customer].permit(:name, :email))
      redirect_to @customer
    else
      render 'edit'

    end
  end
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to customers_path
  end
end
