class MailingList < ActiveRecord::Base
  has_many :mailing_list_emails
  has_many :mailing_lists_products
  has_many :products, through: :mailing_lists_products
  validates_presence_of :name

  after_create :sync

  def subscribers
    self.emails.count
  end

  def emails
    emails = []
    self.products.each do |p|
      emails.concat p.orders.completed.pluck('email')
    end
    emails.uniq
  end

  def remove_sync(provider)
    # don't delete exsisting email, only not sync new
    if provider == 'mailchimp'
      self.mailchimp_list_id = nil
      self.mailchimp_list_name = nil
    end
    if provider == 'createsend'
      self.createsend_list_id = nil
      self.createsend_list_name = nil
    end

    self.save
  end

  private
  def sync
    if !self.mailchimp_list_name.blank? && self.mailchimp_list_id
      MailingListSync.perform_async(self.id, 'mailchimp')
    end
    if !self.createsend_list_name.blank? && self.createsend_list_id
      MailingListSync.perform_async(self.id, 'createsend')
    end
  end

end