class User::Tools::EmailsController < User::BaseController

  def new
   @list = MailingList.find(params[:mailing_list_id])
   @email = MailingListEmail.new
 end

 def create
  # sanitize
  # format
  # save
  # call sidekiq send_emails
 end
end