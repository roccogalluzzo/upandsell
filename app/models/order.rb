class Order < ActiveRecord::Base
  belongs_to :product
  monetize :amount_cents

  before_create { self.token = SecureRandom.urlsafe_base64(16)}
  after_create :send_emails
  after_save :update_metrics

  private
  def update_metrics
    if self.status == 'completed' && self.status_was != 'completed'
      Metric::Products.new(self.product_id).incr_sales
      Metric::Products.new(self.product_id).incr_earnings(self.amount.exchange_to("USD").cents)
    elsif self.status == 'refunded' && self.status_was == 'completed'
     Metric::Products.new(self.product_id).decr_sales(1, self.created_at)
     Metric::Products.new(self.product_id).decr_earnings(self.amount.exchange_to("USD").cents, self.created_at)
   end
 end

 private
 def send_emails
  user = User.find(self.product.user_id)
  UserMailer.bought_email(user, self).deliver
  UserMailer.sold_email(user, self).deliver
end
end