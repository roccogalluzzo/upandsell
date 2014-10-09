class MailingListRemoveSyncWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    user = User.find order.user_id
    order.product.mailing_lists.each do |ml|
      if !ml.mailchimp_list_id.blank?
        chimp = MailingListsService.new('mailchimp', user.mailchimp_token)
        chimp.unsubscribe(ml.mailchimp_list_id, order.email)
      end
      if !ml.createsend_list_id.blank?
        cs = Providers::Createsend.new(user.id)
        cs.unsubscribe(ml.createsend_list_id, order.email)
      end
    end
  end
end