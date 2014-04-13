class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!, :is_admin?
  layout 'admin'

  def is_admin?
    if current_user.admin?
      redirect_to admin_root_path
    else
     redirect_to user_root_path
   end
 end
end