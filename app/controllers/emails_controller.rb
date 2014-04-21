class EmailsController < ApplicationController

  def unsubscribe
    response = User.unsubscribe(
      params[:user], params[:type], params[:signature])
    if response
      render json: {head: :ok} and return
    end
    render json: {status: :not_found}
  end

  def unsubscribe_product_updates
    response = Order.unsubscribe(params[:order], params[:signature])
    if response
      render json: {head: :ok} and return
    end
    render json: {status: :not_found}
  end

end