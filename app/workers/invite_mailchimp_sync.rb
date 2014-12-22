class InviteMailchimpSync
  include Sidekiq::Worker

  def perform(invite_id, subscribe = true)
    api_key = '3201c186e6483c000f50ef007c7e2107-us8'
    invite = Invite.find invite_id

    if subscribe
     subscribe_invite(api_key, invite)
   else
    chimp = MailingListsService.new('mailchimp', api_key)
    chimp.unsubscribe('44bcac056e', invite.email)
  end
end

def subscribe_invite(api_key, invite)

  gb = Gibbon::API.new(api_key)
  gb.lists.subscribe({
    id: '44bcac056e',
    email: {email: invite.email},
    :merge_vars => {'INVITE_COD' => invite.invitation_token},
    double_optin: false
    })
end

end