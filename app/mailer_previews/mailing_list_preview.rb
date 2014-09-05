class MailingListPreview < ActionMailer::Preview
    def newsletter

      mail = MailingListMailer.newsletter()
      mail
    end

  end