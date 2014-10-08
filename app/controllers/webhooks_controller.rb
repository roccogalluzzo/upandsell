class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def mailchimp_unsubscribe
    # bug here, trovare filtrare gli ordini con quella email, partendo dalla
    # mailing list
    order = Order.find_by_email(params[:email])
    order.update_attribute('buyer_accepts_marketing', false)
  end

  def createsend_unsubscribe
  end

end
