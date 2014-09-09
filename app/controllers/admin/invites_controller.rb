class Admin::InvitesController < Admin::BaseController

  def index
    @invites = Invite.all.page(params[:page]).per(8)
    @invite = Invite.new
  end

  def create
    invite = Invite.new
    invite.email = params[:invite][:email]
    invite.status = 'sending'
    if invite.save
      return redirect_to admin_invites_path, notice: 'Invite was created.'
    end
    return redirect_to admin_invites_path, notice: 'Error: Invite not created.'
  end

  def send_invite
   invite = Invite.find params[:id]
   UserMailer.delay.invite_email(invite.id)
    invite.status = 'sending'
    invite.save
    redirect_to admin_invites_path, notice: 'Invite was sent.'
 end
end
