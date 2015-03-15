class ProductsController < ApplicationController
  include CheckoutSession
  include CheckoutProduct

  skip_after_filter :intercom_rails_auto_include
  layout "product"

  def show
    @product = Product.find_by_slug!(params[:slug])
    set_landing_env
    register_visit(@product)
    @user = User.find(@product.user_id)
    set_user_env
    return if !@published
    @coupons = !@product.coupons.active.not_expired.blank?
    #registra pagamento paypal se presente
    return if params[:payKey] && register_paypal_payment(params[:payKey])
    #check sessione se il prodotto risulta gia' acquistato
    set_download_product_env if is_user_product?(@product.id)
  end

  private
  def set_landing_env
    @downloads = 0
    @download_url = '#'
    @accept_marketing = true
    @token = nil
    @title = @product.name
  end

  def set_user_env
    @paypal = @user.paypal_active?
    @ga_code = @user.ga_code
    @credit_card = @user.credit_card_active?
    @published = true if (@paypal || @credit_card) && @product.published && @user.subscribed?
  end

  private
  def set_download_product_env
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

  private
  def register_paypal_payment(pay_key)
    order = Order.where( gateway_token: pay_key).first
    if order.status == 'completed' && order.product_id == @product.id
      update_user_products(order.product.id, order.token)
      @downloads =  order.n_downloads
      @action = 'afterPaypal'
      @downloadable = true if (@downloads < 5)
      @token = order.token
      @accept_marketing = order.buyer_accepts_marketing
      @download_url = download_product_url(order.token)
      return true
    end
    false
  end

  private
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
end
