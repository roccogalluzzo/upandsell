class LandingController < ApplicationController

  layout "home"

  def index
  end

  def beta
    render layout: 'home_beta'
  end

  def beta_request
    invite = Invite.new
    invite.email = params[:invite][:email]
    if invite.save
      render json: {}, status: :ok and return
    end
        render json: {msg: "Email not valid or already registered"}, status: :unprocessable_entity
  end

end