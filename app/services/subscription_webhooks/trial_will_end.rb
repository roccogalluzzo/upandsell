module SubscriptionWebhooks
  class TrialWillEnd
    def call(event)
      user = User.find_by_stripe_id event.data.object.customer
      UserMailer.delay.trial_will_expire_email(user.id) if user
    end
  end
end
