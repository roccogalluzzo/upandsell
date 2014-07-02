class User::Tools::MailingListsController < User::BaseController

  def create
    @list = MailingList.new
    @list.user_id = current_user.id
    Rails.logger.info params
    @list.name = params[:mailing_list][:name]
    @list.products = current_user.products.where(id: params[:mailing_list][:products]) || current_user.products
    @list.save

    redirect_to user_tools_mailing_lists_path
  end

  def index
   @mailing_list = MailingList.new
   @list = MailingList.all
 end

 def show
 end

 def destroy
  MailingList.find(params[:id]).delete
  redirect_to uuser_tools_mailing_lists_path
end

def update

end

def sync
end



end