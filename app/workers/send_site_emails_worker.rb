class SendSiteEmailsWorker
  include Sidekiq::Worker

  def perform(newsletter_id)
   mandrill =  Mandrill::API.new('dKYyD-MAJGBK3CFRa-IEKA')
   email = SiteNewsletter.find newsletter_id

   emails = []
   User.newsletter.each do |u|
     emails << {"email"=> u.email, "name"=> u.name}
   end

   message = {"html"=>  email.content,
    "subject"=> email.subject,
    "from_email"=>"rocco@upandsell.me",
    "from_name"=>"Rocco Galluzzo",
    "to"=> emails,
    "auto_text"=> true,
    "signing_domain"=> 'upandsell.me'
  }
  async = false
  mandrill.messages.send message, async

end
end