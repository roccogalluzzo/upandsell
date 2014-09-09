class UserMailer <  Devise::Mailer
    helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default from: "bot@upandsell.me"
  layout 'email_notifications', except: 'welcome_email'

  def welcome_email(user_id)
    @user = User.find user_id
    @url  = 'http://example.com/login'
    mail(to: @user.email,
      from: 'rocco@upandsell.me',
      subject: 'Welcome to Up&Sell.Me',
      template_path: 'notifications',
      template_name: 'welcome_email')
  end

  def sold_email(user_id, order_id)
    @user = User.find user_id
    @order  = Order.find order_id
    mail(to: @user.email,
     subject: "You sold #{@order.product.name}.",
     template_path: 'notifications',
     template_name: 'sold_email')
  end

  def invite_email(invite_id)
    @invite = Invite.find invite_id
    mail(to: @invite.email,
     subject: "You have been invited to the beta of Up&Sell.Me",
     template_path: 'notifications',
     template_name: 'invite_email')
  end

  def bought_email(user_id, order_id)
    @user = User.find user_id
    @order  = Order.find order_id
    @twitter_url = twitter_url(@order.product.name, @order.product.slug)
    @facebook_url = facebook_url(@order.product.name, @order.product.slug)
    mail(to: @order.email,
     subject: "You bought #{@order.product.name}.",
     template_path: 'notifications',
     template_name: 'bought_email')
  end

  def refund_email(user_id, order_id)
   @user = User.find user_id
   @order  = Order.find order_id
   mail(to: @order.email,
     subject: "You have been refunded.",
     template_path: 'notifications',
     template_name: 'refund_email')
 end

 def paypal_error_email(paykey, ip)
  mail(to: 'rocco@upandsell.me',
   body: "paypal ERROR after buy from #{ip} - paykey: #{paykey}",
   content_type: "text/html",
   subject: "PAYPAL ERROR")
end

private
def facebook_url(name, slug)
  URI.escape(
    "https://www.facebook.com/sharer/sharer.php?u=#{product_slug_url(slug)}&title=#{name}")
end

private
def twitter_url(name, slug)
  URI.escape(
    "https://twitter.com/intent/tweet?text=I bought #{name} #{product_slug_url(slug)}&via=upandsell_me")
end
end
