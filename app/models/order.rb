class Order < ActiveRecord::Base
  belongs_to :product
  monetize :amount_cents

  before_create { self.token = SecureRandom.urlsafe_base64(16)}
  after_save :update_metrics

  private
  def update_metrics
    print self.status
    if self.status == 'completed' && self.status_was != 'completed'
      Metric::Products.new(self.product_id).incr_sales
      Metric::Products.new(self.product_id).incr_earnings(self.amount_cents)
    elsif self.status == 'refunded' && self.status_was == 'completed'
     Metric::Products.new(self.product_id).decr_sales(1, self.created_at)
     Metric::Products.new(self.product_id).decr_earnings(self.amount_cents, self.created_at)
   end
 end
end