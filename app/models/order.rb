class Order < ActiveRecord::Base
  include Unsubscribable

  STATUS_NAMES = %w(created completed refunded)
  belongs_to :product
  belongs_to :user
  monetize :amount_cents
  scope :completed, -> { where status: 'completed' }
  scope :email_starts_with, -> (query) { where("email like ?", "%#{query}%")}
  validates :status, inclusion: { in: STATUS_NAMES }
  serialize :payment_details

  before_create do
    self.token = SecureRandom.urlsafe_base64(16)
    self.amount_base_cents = self.amount.cents.in(self.amount_currency.downcase.to_sym).to(:eur)
    self.buyer_accepts_marketing = true
  end

  after_save :send_emails
  before_save :increment_order_number

  def refund
    if self.gateway != 'paypal'
     service = PaymentService.new('paymill')
   else
      service = PaymentService.new('paypal')
   end
   service.refund(self.gateway_token, self.amount_cents, self.user_id)
   self.status = 'refunded'
   self.save
   end

   private
   def increment_order_number
    if self.status == 'completed' && self.status_was != 'completed'
     user = User.find(self.product.user_id)
     prev_order = user.orders
     .where("status = ? OR status = ?", 'completed', 'refunded')
     .order("id DESC").first
     if prev_order
       prev_number = prev_order.number.to_i
     else
      prev_number = 0
    end

    self.number = prev_number + 1
  end
end

def self.confirm_unsubscribe(id, type, signature)
  unsubscribe(id, type, signature)
end
private
def send_emails
  if self.status == 'completed' && self.status_was != 'completed'
    user = User.find(self.product.user_id)
    UserMailer.delay.bought_email(user.id, self.id)
    Metric::Product.new(self.product).record_sale(self.amount_base_cents)


    if user.email_after_sale
      UserMailer.delay.sold_email(user.id, self.id)
    end

    if self.buyer_accepts_marketing
      MailingListAddSyncWorker.perform_async(self.id)
    end
  end

  if self.status == 'refunded' && self.status_was == 'completed'
    UserMailer.delay.refund_email(self.product.user_id, self.id)
    Metric::Product.new(self.product).delete_sale(self.amount_base_cents, self.created_at)
  end
end
end
