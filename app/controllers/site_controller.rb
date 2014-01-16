class SiteController < ApplicationController

def index
@products = Product.all
end
end
