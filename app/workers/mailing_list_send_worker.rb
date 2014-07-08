class MailingListSendWorker
  include Sidekiq::Worker

  def perform(list_id, email_id)
  end
end