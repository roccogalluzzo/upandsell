class Admin::InvitesController < Admin::BaseController

  def index
    status = params[:status]
    if status == 'sent'
      invites = Invite.sent
    elsif status == 'waiting'
      invites = Invite.waiting
    else
      invites = Invite.used
    end
    @invites = invites.order('invitation_created_at DESC').page(params[:page]).per(8)
    @invite = Invite.new
  end

  def create
    invite = Invite.new
    invite.email = params[:invite][:email]
    invite.status = 'sending'
    if invite.save
      UserMailer.delay.invite_email(invite.id)
      return redirect_to admin_invites_path(status: 'sent'), notice: 'Invite was created.'
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
