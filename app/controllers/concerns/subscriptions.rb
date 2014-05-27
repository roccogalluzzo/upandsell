module Subscriptions extend ActiveSupport::Concern


  def self.create(email, offer, payment_token)
    client = Paymill::Client.create(email: email)
    Paymill::Subscription.create client: "client_64b025ee5955abd5af66",
    offer: "offer_40237e20a7d5a231d99b",
    payment: "pay_95ba26ba2c613ebb0ca8"
  end

  def self.cancel(sub_id)
    Paymill::Subscription.update_attributes(id, cancel_at_period_end: true)
  end

end