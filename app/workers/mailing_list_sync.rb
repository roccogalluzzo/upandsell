class MailingListSync
  include Sidekiq::Worker

  def perform(list_id, provider)
    list = MailingList.find list_id
    user = User.find list.user_id
byebug
    if provider == 'mailchimp'
      ml = MailingListsService.new(provider, user.mailchimp_token)
      ml.batch_subscribe(list.mailchimp_list_id, list.emails)
    end
    if provider == 'createsend'
      ml = MailingListsService.new(provider, user.createsend_token)
      ml.batch_subscribe(list.createsend_list_id, list.emails)
    end
  end
end