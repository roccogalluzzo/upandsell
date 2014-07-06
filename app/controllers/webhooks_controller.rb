class WebhooksController < ApplicationController

  skip_before_filter :verify_authenticity_token


  def mailchimp_unsubscribe
  end

  def createsend_unsubscribe
  end




end