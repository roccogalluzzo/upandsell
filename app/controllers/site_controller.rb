class SiteController < ApplicationController

  layout "site"

  def privacy
  end

  def pricing

  end

  def terms
  end

  def demo
    @user = User.new
    @user.name = 'Mark Twain'
    @user.bio = 'An American author and humorist. I wrote The Adventures of Tom Sawyer and
    Adventures of Huckleberry Finn.'
    @credit_card = true
    @published = true
    @downloads= 0
    @product = dummy_product
    render layout: 'demo'
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

private
def dummy_product
 @product = Product.new
 @product.name = 'The Adventures of Tom Sawyer'
 @product.price = 0
 @product.file_info = {size: 684532}
 @product.file_key = 'demo.pdf'
 @product.description = "
 Most of the adventures in this book really happened. One or two were my own experiences.
The others were experiences of boys in my school. Huck Finn really
lived. Tom Sawyer is made of three real boys.
My book is for boys and girls, but I hope that men and women
also will read it. I hope that it will help them to remember pleasantly
the days when they were boys and girls, and how they felt and thought
and talked, what they believed, and what strange things they sometimes
did.
 "
 @product
end
end
