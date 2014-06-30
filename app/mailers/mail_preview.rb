  # app/mailers/mail_preview.rb or lib/mail_preview.rb
  class MailPreview < MailView
    # Pull data from existing fixtures
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

    # Stub-like
    def forgot_password
      user = Struct.new(:email, :name).new('name@example.com', 'Jill Smith')
      mail = UserMailer.forgot_password(user)
    end
  end