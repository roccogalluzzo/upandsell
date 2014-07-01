class MailPreview < ActionMailer::Preview
    def sold_email
      user = User.first
      order = Order.first
      mail = UserMailer.sold_email(user, order)
      mail
    end
    def bought_email
      user = User.first
      order = Order.first
      mail = UserMailer.bought_email(user, order)
      mail
    end
    # Factory-like pattern
    def welcome
      user = User.first
      mail = UserMailer.welcome_email(user)
      mail
    end
  end