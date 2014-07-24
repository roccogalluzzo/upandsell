class SendEmailsWorker
  include Sidekiq::Worker

  def perform(list_id, email_id)
    #TODO Format as

    emails = [
        {email:'roccoc@galluzzo.me'}
    ]
    email = {subject: 'ciao', body: '<p>ciao ciao</p>'}
    m = Mandrill::API.new(Rails.application.secrets.mandrill['api_key'])
    premailer = Premailer.new(email['body'], {with_html_string: true})

    message = {
       text:  premailer.to_plain_text,
       from_email: 'roccoc@galluzzo.me', #user.email,
       html:  premailer.to_inline_css,
       to: emails,
       from_name: 'Rocco', #user.name,
       subject: email['subject']
    # signing_domain: nil,
     #headers: {"Reply-To" => "message.reply@example.com"
 }

 result = m.messages.send(message)
        # [{"reject_reason"=>"hard-bounce",
        #     "status"=>"sent",
        #     "_id"=>"abc123abc123abc123abc123abc123",
        #     "email"=>"recipient.email@example.com"}]


    end
end