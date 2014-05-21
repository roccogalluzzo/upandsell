class ProductsController < ApplicationController
  layout "product"
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def show
    #@product = Product.get("products?slug=#{params[:slug]}")[0]
    api = Product.new
    @product = api.find_by_slug(params[:slug])

    (render(status: :not_found) and return) if !@product.present?
    @title = @product.name
   # register_visit(@product)
    @user = User.find(@product.user_id)
    @paypal = @user.paypal
    @ga_code = @user.ga_code
    @credit_card = @user.credit_card
    @published = true if (@paypal || @credit_card) && @product.published
    @action = @credit_card ? 'buy': 'buyPaypal'
    @downloadable = false
 #registra pagamento paypal se presente
 if params[:payKey]
  order = Order.where( gateway_token: params[:payKey])
  if order.status == 'completed' && order.product_id == @product.id
    update_user_products(order.product.id, order.token)
    @downloads =  order.n_downloads
    @action = 'afterPaypal'
    @downloadable = true if (@downloads < 5)
    @token = order.token
    return
  end

end

#check sessione se il prodotto risulta gia' acquistato
if is_user_product?(@product.id)
  order = Order.where(token: session[:user_products][@product.id])
  if order.present? && order.status == 'completed'
    @downloads =  order.n_downloads
    @action = 'download' if (@downloads < 5)
    @downloadable = true if (@downloads < 5)
    @token = order.token
  end
end
end


private
def register_visit(product)
  ua = AgentOrange::UserAgent.new(request.env['HTTP_USER_AGENT'])
  unless ua.is_bot?
    Metric::Products.new(product.id).incr_visits
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
