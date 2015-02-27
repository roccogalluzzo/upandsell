module SubscriptionWebhooks
  class PaymentFailed
    def call(event)
      data = event['data']
      user = User.find_by!(stripe_id: data['customer'])
      SubscriptionPayment.new(
        user_id: user.id,
        stripe_payment_id: data['object']['id'],
        amount_due_cents: data['object']['amount_due'],
        amount_due_currency: data['object']['currency'],
        period_start: Time.at(data['object']['period_start']).to_datetime,
        period_end: Time.at(data['object']['period_end']).to_datetime,
        plan:  data['object']['subscription'],
        created_at: Time.now,
        status: 'failed'
        ).save

      # send emails
    end
  end
end
