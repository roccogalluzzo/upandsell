class SiteController < ApplicationController
layout "home"
def index
@products = Product.all
end
end
