class MailingListMailer <  ActionMailer::Base

  layout 'email_notifications'

  def  newsletter
    mail(to: 'ciao@gmail.com',
      from: 'rocco@upandsell.me',
      subject: 'Welcome to Up&Sell.Me',
      template_path: 'mailing_lists',
      template_name: 'newsletter')
  end

end