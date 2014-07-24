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
  end

  after_save :send_emails
  before_save :increment_order_number

  def refund
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

private
def send_emails
  if self.status == 'completed' && self.status_was != 'completed'
    user = User.find(self.product.user_id)
    UserMailer.delay.bought_email(user, self)
    Metric::Product.new(self.product).record_sale(self.amount_base_cents)


    if user.email_after_sale
      UserMailer.delay.sold_email(user, self)
    end

    if self.buyer_accepts_marketing
      MailingListAddSyncWorker.perform(self.id)
    end
  end

  if self.status == 'refunded' && self.status_was == 'completed'
    UserMailer.delay.refund_email(user, self)
    Metric::Product.new(self.product).delete_sale(self.amount_base_cents, self.created_at)
  end
end
end
