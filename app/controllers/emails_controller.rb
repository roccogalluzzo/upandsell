class EmailsController < ApplicationController

  def unsubscribe_user

  end

  def confirm_unsubscribe_user
    response = User.unsubscribe(
      params[:user], params[:type], params[:signature])
    if response
      render "emails/unsubscribed"
      return
    end
    render 'unsubscribe_user' and return
  end

  def unsubscribe_order
    response = Order.unsubscribe(params[:order], params[:signature])
    if response
     return
   end
   render json: {status: :not_found}
 end

 def confirm_unsubscribe_order
  response = Order.unsubscribe(params[:order], params[:signature])
  if response
    render "emails/unsubscribed"
    return
  end

  render 'unsubscribe_order' and return
end

def unsubscribed
end
end