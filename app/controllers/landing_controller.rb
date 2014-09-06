class LandingController < ApplicationController

 layout "home"


 def index
 end

 def beta
render :layout => 'home_beta'
 end
end