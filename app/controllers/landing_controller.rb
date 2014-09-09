class LandingController < ApplicationController

  layout false

  def index
    if !params[:nobeta].blank?
      Upandsell::Application.config.beta = false
    end
  end

  def beta
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