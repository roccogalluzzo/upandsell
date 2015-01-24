module SubscriptionWebhooks
  class TrialWillEnd
    def call(event)
      data = event.data
      user = User.find_by_stripe_id data['customer']
      UserMailer.delay.trial_will_end_email(user.id)
    end
  end
end
