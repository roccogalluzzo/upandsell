class User::Settings::EmailsController < User::BaseController

  def edit
    @subject = current_user.custom_email_message[:subject] || 'Thanks for the purchase!'
    @text = current_user.custom_email_message[:text] || 'You can download it by clicking the link below:'
  end

  def update
    user = current_user
    if params[:button] == 'reset'
      user.custom_email_message[:subject] =  nil
      user.custom_email_message[:text] =  nil
    else
      user.custom_email_message[:subject] =  ActionController::Base.helpers.sanitize(params[:user][:subject]).html_safe
      user.custom_email_message[:text] =  ActionController::Base.helpers.sanitize(params[:user][:text]).html_safe
    end
    if user.save
      redirect_to edit_user_settings_emails_path,
      notice: 'Email Custom Message Updated' and return
    end
    render 'edit'
  end
end