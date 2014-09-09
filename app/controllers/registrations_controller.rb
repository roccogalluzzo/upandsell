class RegistrationsController < Devise::RegistrationsController

  def new
    if params[:invite_token]
      @invite = Invite.find_by_invitation_token params[:invite_token]

    else
      redirect_to root_path and return
    end


    # if param not present show beta error message
    if params[:ref]
     @ref = params[:ref]
   else
    @ref = cookies[:aff_tag]
  end
  super
end

def create
  if params[:invitation_token]
    @invite = Invite.find_by_invitation_token params[:invitation_token]
    if @invite.status == 'used'
      redirect_to root_path and return
    end
    @invite.status = 'used'
    @invite.save
  else
    redirect_to root_path and return
  end

  super
end


protected
def after_inactive_sign_up_path_for(resource)
  user_setup_path
end

def after_sign_up_path_for(resource)
  user_setup_path
end
end