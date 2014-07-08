class MailingListRemoveSyncWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    # check if current order is inside any mailing list, if sync new email
    ml.subscribe(list.provider_list_id, order.email)
  end
end