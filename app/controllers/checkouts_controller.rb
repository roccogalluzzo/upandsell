class CheckoutsController < ApplicationController
  include Gateways
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def pay_info
    product = Product.new.find(params[:product_id])
    render json: { price: product.price, currency: product.currency.upcase }
  end

  def pay
    product = Product.new.find(params[:product_id])

    order = Gateways::pay(product, 'paymill',
      { email: params[:email], token: params[:token]})

    if order && order.status == 'closed'
      url = download_product_url(order.token)
      #update_user_products(product.id, order.token)
      render json: { url: url }, status: :ok and return
    end
    render json: {error: order[:error]}, status: :unauthorized and return
  end

  def paypal
    url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
    product = Product.new.find(params[:product_id])

    order = Gateways::pay(product, 'paypal',
    {
      cancel_url: product_url(id: product.id, payment: 'failed'),
      return_url: checkout_check_payment_url(id: product.id)
      })

    if order
      render json: { url:  url + order.gateway_token }, status: :ok and return
    end

    render json: {}, status: :unprocessable_entity
  end

  def download
    order = Order.where(token: params[:token])
    if order.n_downloads < 5 && order.status == 'completed'
      redirect_to order.product.expiring_url
      order.increment!(:n_downloads)
      return
    end
    head(:unauthorized)
  end

  def ipn
    if PayPal::SDK::Core::API::IPN.valid?(request.raw_post)
      order = Order.new.find_by(gateway_token: params["pay_key"])
      if order && order.status != 'refunded' && params["status"].downcase == "completed"
        order.status = 'closed'
        order.email = params["sender_email"]
        head(:ok) if order.update
      end
    end

  end

  def check_paypal_payment
   tries ||= 5
   if payment_completed?(params[:payKey])
    redirect_to download_url(params[:payKey])
    return
  else
    5.times do
      sleep(2)
      if payment_completed?(params[:payKey])
        redirect_to download_url(params[:payKey])
        return
      end
    end
    Rails.logger.error "Paypal Error after buy from #{request.remote_ip} - paykey: #{params[:payKey]}"
    UserMailer.paypal_error_email(params[:payKey], request.remote_ip)
    @title = "Paypal Error"
    render 'paypal_error'
  end
end

def download_url(pay_key)
  order = Order.new.find_by(gateway_token: pay_key)
  product = Product.new.find(order.product_id)
  return product_slug_url(slug: product.slug, payKey: pay_key)
end

def payment_completed?(pay_key)
 order = Order.new.find_by( gateway_token: pay_key)
 if order and order.status == 'closed'
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