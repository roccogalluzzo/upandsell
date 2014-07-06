class MailingListSyncWorker
  include Sidekiq::Worker

  def perform(list_id, provider, provider_list_id)
    list = MailingList.find list_id
    user = User.find list.user_id
    ml = MailingListsService.new('mailchimp', user.mailchimp_token)
    ml.batch_subscribe(provider_list_id, list.emails)
  end
end