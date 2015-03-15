module CheckoutSession extend ActiveSupport::Concern
  included do
    before_action :set_session
  end

  def set_session
    unless session[:user]
      session[:user] = {}
      session[:user][:visits] = []
      session[:user][:last_visit] = Time.now
    end
  end

  def update_user_products(product_id, token)
    session[:user_products] ||= {}
    session[:user_products][product_id] = token
  end

  def is_user_product?(product_id)
    return true if session[:user_products] and
    session[:user_products].key? product_id
  end
end
