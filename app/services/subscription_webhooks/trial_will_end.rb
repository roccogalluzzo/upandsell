module SubscriptionWebhooks
  class TrialWillEnd
    def call(event)
      data = event.data
      user = User.find_by_stripe_id event.data.object.customer
      if user
        UserMailer.delay.trial_will_expire_email(user.id)
      end
    end
  end
end

