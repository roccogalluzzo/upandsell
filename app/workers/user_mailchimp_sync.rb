class UserMailchimpSync
  include Sidekiq::Worker

  def perform(user_id, subscribe = true)
    api_key = '3201c186e6483c000f50ef007c7e2107-us8'
    user = User.find user_id
    if subscribe
      subscribe_user(api_key, user)
    else
     chimp = MailingListsService.new('mailchimp', api_key)
     chimp.unsubscribe('3c3895a8b6', user.email)
   end
 end

 def subscribe_user(api_key, user)

  gb = Gibbon::API.new(api_key)

  first, last = user.name.split
  gb.lists.subscribe({
    id: '3c3895a8b6',
    email: {email: user.email},
    :merge_vars => {'ID' => user.id, :FNAME => first, :LNAME => last},
    double_optin: false
    })
end

end