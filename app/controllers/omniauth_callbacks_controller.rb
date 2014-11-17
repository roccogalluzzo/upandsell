class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.facebook_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    @user = User.find_for_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.google_oauth2_data"] = env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_sign_up_path_for(resource)
    user_setup_path
  end
end