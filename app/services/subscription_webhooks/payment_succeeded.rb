module SubscriptionWebhooks
  class PaymentSucceeded
    def call(event)

      data = event['data']
      user = User.find_by!(stripe_id: data['customer'])
      payment = SubscriptionPayment.find_by_stripe_payment_id(data['object']['id'])
      if payment
        payment.status = 'payed'
        payment.payed_at = Time.now
        payment.save
      else
        SubscriptionPayment.new(
          user_id: user.id,
          stripe_payment_id: data['object']['id'],
          amount_due_cents: data['object']['amount_due'],
          amount_due_currency: data['object']['currency'],
          period_start: Time.at(data['object']['period_start']).to_datetime,
          period_end: Time.at(data['object']['period_end']).to_datetime,
          plan:  data['object']['subscription'],
          created_at: Time.now,
          payed_at: Time.now,
          status: 'payed'
          ).save
      end

        # send emails
      end
    end
  end
