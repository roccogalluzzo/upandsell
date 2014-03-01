class User::BaseController < ApplicationController
  before_filter :authenticate_customer!
  layout 'application'
end