module SubscriptionWebhooks
  class CustomerSubscriptionDeleted
    def call(event)
      user = User.find_by_stripe_id event['data']['object']['customer']
      # send emails
      user.deleted_subscription
      UserMailer.delay.subscription_deleted_email(user.id) if user
    end
  end
end
