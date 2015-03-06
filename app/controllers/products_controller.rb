class ProductsController < ApplicationController
  skip_after_filter :intercom_rails_auto_include
  layout "product"
  before_action :set_session
  def show
    @downloads = 0
    @download_url = '#'
    @accept_marketing = true
    @token = nil

    @product = Product.find_by_slug!(params[:slug])
    register_visit(@product)
    @title = @product.name
    @user = User.find(@product.user_id)
    @paypal = @user.paypal_active?
    @ga_code = @user.ga_code
    @credit_card = @user.credit_card_active?
    @published = true if (@paypal || @credit_card) && @product.published && @user.subscribed?
    return if !@published

    @coupons = !@product.coupons.active.not_expired.blank?

    #registra pagamento paypal se presente
    if params[:payKey]
      order = Order.where( gateway_token: params[:payKey]).first
      if order.status == 'completed' && order.product_id == @product.id
        update_user_products(order.product.id, order.token)
        @downloads =  order.n_downloads
        @action = 'afterPaypal'
        @downloadable = true if (@downloads < 5)
        @token = order.token
        @accept_marketing = order.buyer_accepts_marketing
        @download_url = download_product_url(order.token)
        return
      end
    end

    #check sessione se il prodotto risulta gia' acquistato
    if is_user_product?(@product.id)
      order = Order.where(token: session[:user_products][@product.id]).first
      if order.present? && order.status == 'completed'
        @downloads =  order.n_downloads
        @action = 'download' if (@downloads < 5)
        @downloadable = true if (@downloads < 5)
        @token = order.token
        @accept_marketing = order.buyer_accepts_marketing
        @download_url = download_product_url(order.token)
      end
    end
  end

  private
  def set_session
    unless session[:user]
      session[:user] = {}
      session[:user][:visits] = []
      session[:user][:last_visit] = Time.now
    end
  end

  private
  def register_visit(product)
    ua = AgentOrange::UserAgent.new(request.env['HTTP_USER_AGENT'])

    if !ua.is_bot? && !session[:user][:visits].include?(product.id) && session[:user][:last_visit] >  30.minutes.ago
      Metric::Product.new(product).record_visit
      session[:user][:visits] << product.id
      session[:user][:last_visit] = Time.now
    end
  end

  def download_url(pay_key)
    order = Order.where(gateway_token: pay_key)
    product = Product.find(order: product_id)
    return product_slug_url(slug: product.slug, payKey: pay_key)
  end

  def payment_completed?(pay_key)
   order = Order.where( gateway_token: pay_key)
   if order and order.status == 'completed'
     return true
   end
   return false
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
