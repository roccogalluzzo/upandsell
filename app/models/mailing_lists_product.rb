class MailingListsProduct < ActiveRecord::Base
  belongs_to :mailing_list
  belongs_to :product
end