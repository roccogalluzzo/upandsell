module SubscriptionWebhooks
  class CustomerSubscriptionUpdated
    def call(event)
      user = User.find_by_stripe_id event['data']['object']['customer']
      user.renew_subscription(event['data']['object'])
    end
  end
end
