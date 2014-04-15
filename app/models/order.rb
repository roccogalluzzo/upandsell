class Order < ActiveRecord::Base
  belongs_to :product
  monetize :amount_cents
  monetize :amount_base_cents

  before_create { self.token = SecureRandom.urlsafe_base64(16)}
  before_create {self.amount_base = self.amount.exchange_to('EUR')}
  after_save :update_metrics

  private
  def update_metrics
    if self.status == 'completed' && self.status_was != 'completed'
     user = User.find(self.product.user_id)
     UserMailer.delay.bought_email(user, self)
     UserMailer.delay.sold_email(user, self)
   end
 end

end