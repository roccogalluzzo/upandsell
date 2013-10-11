class Customer::BaseController < ApplicationController
  layout "customers"
#before_filter :authenticate_customer!
end