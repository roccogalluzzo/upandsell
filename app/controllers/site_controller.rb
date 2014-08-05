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
 @product.price = 12
 @product.file_info = {size: 123456}
 @product.file_key = 'demo.pdf'
 @product.description = "
 The Adventures of Tom Sawyer by Mark Twain is
 an 1876 novel about a young boy growing up along the Mississippi River.
 he story is set in the fictional town of St. Petersburg, inspired by
  Hannibal, Missouri, where Twain lived. Tom Sawyer lives with his Aunt
   Polly and his half-brother Sid. Tom dirties his clothes in a fight
   and is made to whitewash the fence the next day as punishment.
"
 @product
end
end
