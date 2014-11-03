class Coupon < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  scope :active, -> { where(status: 'active') }
  scope :not_expired, -> {where('expire <= ?', Time.now)}
  monetize :discount_money_cents

  def active?
    if (self.available == nil || (self.available >= self.used)) &&
      (self.expire == nil || (self.expire < Time.now))
      return true
    end
    false
  end
  def discounted_price
    if self.discount_type == 'cents'
      (self.product.price - self.discount_money).price
    else
      self.product.price - Money.new(((self.product.price.cents * self.discount)/100), product.price_currency)
    end
  end

  def is_valid?
    true if  self.discounted_price < self.product.price
  end
end