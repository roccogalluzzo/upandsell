namespace :mailchimp do
  desc "Sync Users To Mailchimp"
  task sync_users: :environment do
    User.all.each do |user|
      UserMailchimpSync.perform_async(user.id)
    end
  end
end
