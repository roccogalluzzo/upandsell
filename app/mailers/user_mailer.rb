class UserMailer < ActionMailer::Base
  default from: "rocco@upandsell.me"

  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email,
     subject: 'Welcome to Up&Sell.Me',
     template_path: 'notifications',
     template_name: 'welcome_email')
  end

  def sold_email(user, order)
    @user = user
    @order  = order
        mail(to: @user.email,
     subject: "You sold #{@order.product.name}.",
     template_path: 'notifications',
     template_name: 'sold_email')
  end

   def bought_email(user, order)
    @user = user
    @order  = order
        mail(to: @order.email,
     subject: "You bought #{@order.product.name}.",
     template_path: 'notifications',
     template_name: 'bought_email')
  end

  def paypal_error_email(paykey, ip)
      mail(to: 'rocco@upandsell.me',
         body: "paypal ERROR after buy from #{ip} - paykey: #{paykey}",
         content_type: "text/html",
         subject: "PAYPAL ERROR")
  end
end
