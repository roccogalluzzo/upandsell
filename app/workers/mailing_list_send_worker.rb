class MailingListSendWorker
  include Sidekiq::Worker

  def perform(list_id, message_id)
  end
end