class MailingListSyncWorker
  include Sidekiq::Worker

  def perform(list_id, provider)
    list = MailingList.find list_id
    user = User.find list.user_id
    ml = MailingListsService.new(provider, user.mailchimp_token)
    ml.batch_subscribe(list.id)
  end
end