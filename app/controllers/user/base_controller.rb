class User::BaseController < ApplicationController
  before_filter :authenticate_user!
  layout 'application'
  include SignInAs

  before_action :was_admin

  def was_admin
    @was_admin = self.remember_admin_id?
  end
end