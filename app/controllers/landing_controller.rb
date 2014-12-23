class LandingController < ApplicationController
  skip_after_filter :intercom_rails_auto_include
  layout false

  def index
     @beta = true
    if !params[:nobeta].blank?
     @beta = false
    end
  end

  def beta
  end

end
