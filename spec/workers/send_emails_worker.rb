require "rails_helper"

describe SendEmailsWorker do

  it "send emails with mandrill api" do
    ml = create(:mailing_list)
    email = ml.mailing_list_emails.create()
    SendEmailsWorker.perform(ml.id, email.id)
    expect(user.admin?).to eq(true)
  end

end
