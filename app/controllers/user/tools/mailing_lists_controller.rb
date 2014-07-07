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
    @list.products = current_user.products.where(id: params[:mailing_list][:products]) || current_user.products
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
    # api search call
    # format response
    @provider = params[:provider_search][:provider]
    @lists = [{id: 1, name: 'list 1'}, {id: 2, name: 'list 2'},
      {id: 3, name: 'list 3'},
      {id: 4, name: 'list 4'},
      {id: 5, name: 'list 5'},
      {id: 6, name: 'list 6'}].sort_by{ rand }
      .slice(0...rand(5))
      respond_to do |format|
        format.js {}
      end
    end


    def create_sync
      # save to db
      # call sideqik task
      @provider = params[:provider_sync][:provider]
      list_id =  params[:provider_sync][:provider_list_id]
      @list_name = MailingList.find(params[:id]).name
      respond_to do |format|
        format.js {}
      end
    end

    def remove_sync
      # call sideqik task
      @provider = params[:provider_unsync][:provider]
      respond_to do |format|
        format.js {}
      end
    end
  end
