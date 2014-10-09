class Providers::Createsend
  include ActiveSupport::Rescuable

  rescue_from CreateSend::ExpiredOAuthToken do |ex|
    access_token, expires_in, refresh_token = @cs.refresh_token
    @user.createsend_token = {access_token: access_token, refresh_token: refresh_token}
    @user.save
  end
  rescue_from CreateSend::BadRequest do |ex|
    return true
  end

  def initialize(user_id)
    @user = User.find(user_id)
    @cs = CreateSend::CreateSend.new(@user.createsend_token)
  end

  def clients
    @cs.clients
  end

  def lists(client_id)
    CreateSend::Client.new(@user.createsend_token, client_id).lists

  end

  def batch_subscribe(list_id, emails)
    batch = []
    emails.each do |email|
      batch << {EmailAddress: email}
    end
    CreateSend::Subscriber.import(@cs.auth_details, list_id, batch, false)
  end

  def subscribe(list_id, email)
    CreateSend::Subscriber.add(@cs.auth_details, list_id, email, '', '', false)
  end

  def unsubscribe(list_id, email)
    CreateSend::Subscriber.new(@cs.auth_details, list_id, email).unsubscribe
  end

end
