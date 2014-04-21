class SiteController < ApplicationController
  layout "site"

  def privacy

  end

  def terms

  end

  def unsubscribe
   if user = User.read_access_token(params[:signature])
    user.update_attribute :email_opt_in, false
    render text: "You have been unsubscribed"
  else
    render text: "Invalid Link"
  end
end

def test
 @user = User.find 1

end
end
