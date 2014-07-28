class User::Tools::MailingListsController < User::BaseController

  def index
    @mailing_list = MailingList.new
    @list = MailingList.all
  end

  def new
    @mailing_list = MailingList.new
    @list = MailingList.all
    respond_to do |format|
      format.js { render :partial => "form" }
    end
  end

  def create
    @list = MailingList.new
    @list.user_id = current_user.id
    @list.name = params[:mailing_list][:name]
    if params[:mailing_list][:products].blank?
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

  def sync
    @list = MailingList.find params[:id]
    respond_to do |format|
      format.js {render :partial => "sync_modal"}
    end
  end

  def search
    @provider = 'mailchimp'
    # api search call
    ml_service = MailingListsService.new(@provider, current_user.send("#{@provider}_token"))
    @lists = ml_service.search(params[:q])
    lists = @lists.map {|l| l.slice 'name'}
    #lists = @lists.map {|l| l['name']}
    render json: lists
  end


  def create_sync
      # save to db
      @provider = params[:provider_sync][:provider]
      if @provider == 'mailchimp'
        @list = MailingList.find(params[:id])
        @list.mailchimp_list_id = params[:provider_sync][:provider_list_id]
        @list.mailchimp_list_name = params[:provider_sync][:provider_list_name]
        @list_name = params[:provider_sync][:provider_list_name]
      end
      if @list.save
        MailingListSync.perform_async(@list.id, @provider)
      end

      respond_to do |format|
        format.js {}
      end
    end

    def remove_sync
      # don't delete exsisting email, only not sync new
      @provider = params[:provider_unsync][:provider]
      if @provider == 'mailchimp'
        @list = MailingList.find(params[:id])
        @list.mailchimp_list_id = nil;
        @list.mailchimp_list_name = nil
      end
      @list.save
      respond_to do |format|
        format.js {}
      end
    end
  end
