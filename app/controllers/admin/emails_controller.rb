class Admin::EmailsController < Admin::BaseController

  def index
    @email = SiteNewsletter.new
  end

  def create
    emails = []
    if  params[:commit] == 'Send'
      @email = SiteNewsletter.new
      @email.content = params['/admin/emails']["content"]
      @email.subject =  params['/admin/emails'][:subject]
      @email.save
      SendSiteEmailsWorker.perform_async(@email.id)
    else
      first, last = current_user.name.split
      send_test_email(current_user.email, first, params['/admin/emails'][:subject], params['/admin/emails']["content"])
    end
    respond_to do |format|
        format.js
      end
    end

    def send_test_email(email, name, subject, content)
     mandrill =  Mandrill::API.new('dKYyD-MAJGBK3CFRa-IEKA')

     message = {"html"=> content,
       "subject"=> subject,
       "from_email"=>"rocco@upandsell.me",
       "from_name"=>"Rocco from Up&Sell.Me",
       "to"=> [{"email"=> email, "name"=> name}],
       "auto_text"=> true,
       "signing_domain"=> 'upandsell.me'
     }
     async = false
     mandrill.messages.send message, async
   end
 end
