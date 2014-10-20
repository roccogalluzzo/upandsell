class User::Tools::MailingListsController < User::BaseController

  def index
    @mailing_list = MailingList.new
    @list = MailingList.where(user_id: current_user.id).page(params[:page]).per(8)
  end

  def new
    @mailing_list = MailingList.new
    @list = MailingList.where(user_id: current_user.id).page(params[:page]).per(8)
    respond_to do |format|
      format.js { render :partial => "form" }
    end
  end

  def create
    @list = MailingList.new(ml_params)
    @list.user_id = current_user.id
    if params[:mailing_list][:products].first == '0'
      @list.products = current_user.products
    else
      @list.products = current_user.products.where(id: params[:mailing_list][:products])
    end
    @list.save
    respond_to do |format|
      format.js {}
    end
  end

  def destroy
    MailingList.find(params[:id]).delete
    @id = params[:id]
    respond_to do |format|
      format.js {}
    end
  end


  def search
    @provider = 'mailchimp'
    # api search call
    ml_service = MailingListsService.new(@provider, current_user.send("#{@provider}_token"))
    @lists = ml_service.search(params[:q])
    lists = @lists.map {|l| l.slice('id', 'name')}
    #lists = @lists.map {|l| l['name']}
    render json: lists
  end

  def createsend_clients
   render json: Providers::Createsend.new(current_user.id).clients
 end

 def createsend_lists
   render json: Providers::Createsend.new(current_user.id).lists(params[:cs_client_id])
 end

 private
 def ml_params
  p = params.require(:mailing_list).permit(:name,
    :mailchimp_list_name,
    :mailchimp_list_id,
    :createsend_list_id,
    :createsend_list_name)

  if p[:createsend_list_id] == 'Choose a List'
    p[:createsend_list_id] = ''
  end
  p
end

end


