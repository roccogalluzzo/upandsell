class User::MailingListsController < User::BaseController

  def create
    @list = MailingList.new
    @list.user_id = current_user.id
    Rails.logger.info params
    @list.name = params[:mailing_list][:name]
    @list.products = current_user.products.where(id: params[:mailing_list][:products]) || current_user.products
    @list.save

    redirect_to user_mailing_lists_path
  end

  def index
   @mailing_list = MailingList.new
   @list = MailingList.all
   render template: 'user/tools/newsletter'
 end

 def show
   render template: 'user/tools/newsletter_send'
 end

 def destroy
  MailingList.find(params[:id]).delete
  redirect_to user_mailing_lists_path
end

def update

end

def sync
end



end