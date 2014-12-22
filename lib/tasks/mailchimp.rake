namespace :mailchimp do
  desc "Sync Users To Mailchimp"
  task sync_users: :environment do
    User.all.each do |user|
      UserMailchimpSync.perform_async(user.id)
    end
  end

  desc "Sync Invites with mailchimp"
  task sync_invites: :environment do
    Invite.sent.each do |invite|
      InviteMailchimpSync.perform_async(invite.id)
    end
  end

end
