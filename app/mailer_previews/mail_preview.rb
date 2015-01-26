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

  def refund_email
    user = User.first
    order = Order.first
    mail = UserMailer.refund_email(user, order)
    mail
  end

  def welcome
    user = User.first
    mail = UserMailer.welcome_email(user)
    mail
  end

  def trial_will_expire
    user = User.first
    mail = UserMailer.trial_will_expire_email(user)
    mail
  end

  def payment_succeeded
    user = User.first
    mail = UserMailer.payment_succeeded_email(user)
    mail
  end

  def subscription_cancelled
    user = User.first
    mail = UserMailer.subscription_deleted_email(user)
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