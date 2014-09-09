class MailPreview < ActionMailer::Preview
    def sold_email
      user = User.first
      order = Order.first
      mail = UserMailer.sold_email(user, order)
      mail
    end
      def invite_email
      invite = Invite.first
      mail = UserMailer.invite_email(invite)
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
     def confirmation_instructions
UserMailer.confirmation_instructions(User.first, {})
end

def reset_password_instructions
  UserMailer.reset_password_instructions(User.first, {})
end

def unlock_instructions
  UserMailer.unlock_instructions(User.first, {})
end
  end