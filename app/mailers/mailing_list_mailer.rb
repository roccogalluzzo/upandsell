class MailingListMailer <  ActionMailer::Base

  layout 'email_notifications'
  default from: "Up&Sell.me <bot@upandsell.me>"

  def  newsletter
    mail(to: 'ciao@gmail.com',
      subject: 'Welcome to Up&Sell.Me',
      template_path: 'mailing_lists',
      template_name: 'newsletter')
  end

end