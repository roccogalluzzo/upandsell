class MailingListSyncWorker
  include Sidekiq::Worker

  def perform(list_id)
  end
end