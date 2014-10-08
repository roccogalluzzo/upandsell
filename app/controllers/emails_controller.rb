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
  end

  def confirm_unsubscribe_order
    response = Order.confirm_unsubscribe(params[:order], params[:type], params[:signature])
    if response
      MailingListRemoveSyncWorker.perform_async(params[:order])
      render "emails/unsubscribed"
      return
    end

    render 'unsubscribe_order' and return
  end

  def unsubscribed
  end
end