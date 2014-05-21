class CheckoutsController < ApplicationController
  include Gateways
  skip_before_filter :verify_authenticity_token, :only => [:ipn]

  def pay_info
    product = Product.find(params[:product_id])
    if product
      render json: { price: product['price'], currency: product['currency'].upcase } and return
    end
    render json: {}, status: :not_found
  end

  def pay
    product = Product.find(params[:product_id])

    if product
      #user  = product.user
      pay = Gateways::pay(product, 'paymill', params[:token])
      order = Order.new(
        email: params[:email],
        gateway: 'paymill',
        gateway_token: pay.id,
        status: 'completed',
        amount: product['price'],
        cc_type: pay.payment['card_type'])

      if pay.status == 'closed' && params[:email].present? && order.save
        url = download_product_url(order.token)
        update_user_products(order.product.id, order.token)
        render json: { url: url }, status: :ok and return
      end
      render json: {error: pay.response_code}, status: :unauthorized and return
    end
    render json: {}, status: :unprocessable_entity and return
  end

  def paypal
    url = "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey="
    product = Product.find(params[:product_id])
    #user  = product.user
    if product
      response = Gateways::pay(product, 'paypal',
        product_url(id: product.id, payment: 'failed'),
        products_check_payment_url(id: product.id))

      order = Order.new(
        email: params[:email],
        gateway: 'paypal',
        gateway_token: response.payKey,
        status: 'created',
        cc_type: 'paypal',
        amount: product.price.cents,
        currency: product.price_currency.upcase)

      if response.success? and order.save
        render json: { url:  url + response.payKey }, status: :ok and return
      end
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
      order = Order.where(payment_token: params["pay_key"])
      if order && order.status != 'refunded' && params["status"].downcase == "completed"
        order.status = 'completed'
        order.email = params["sender_email"]
        order.save
      end

    end
    render nothing: true

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
end