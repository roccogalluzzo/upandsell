class MailingList < ActiveRecord::Base
  has_many :mailing_list_emails
  has_many :mailing_lists_products
  has_many :products, through: :mailing_lists_products
  validates_presence_of :name

  def subscribers
    counter = 0
    self.products.each do |p|
      counter += p.orders.completed.count
    end
    counter
  end

  def emails
    emails = []
    self.products.each do |p|
      emails.concat p.orders.completed.pluck('email')
    end
    emails.uniq
  end
end