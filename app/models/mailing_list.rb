class MailingList < ActiveRecord::Base
  has_many :mailing_list_emails
  has_many :mailing_lists_products
  has_many :products, through: :mailing_lists_products
  validates_presence_of :name

  def subscribers
    self.products.orders.count
  end
end