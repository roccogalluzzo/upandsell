class Providers::Createsend
  include ActiveSupport::Rescuable

  rescue_from CreateSend::ExpiredOAuthToken, with: :refresh_token

  rescue_from CreateSend::BadRequest do |ex|
    return true
  end

  def initialize(user_id)
    @user = User.find(user_id)
    @cs = CreateSend::CreateSend.new(@user.createsend_token)
  rescue Exception => exception
    rescue_with_handler(exception) || raise(exception)
  end

  def clients
    @cs.clients
  rescue Exception => exception
    rescue_with_handler(exception) || raise(exception)
  end

  def lists(client_id)
    CreateSend::Client.new(@user.createsend_token, client_id).lists
  rescue Exception => exception
    rescue_with_handler(exception) || raise(exception)
  end

  def batch_subscribe(list_id, emails)
    batch = []
    emails.each do |email|
      batch << {EmailAddress: email}
    end
    CreateSend::Subscriber.import(@cs.auth_details, list_id, batch, false)
  rescue Exception => exception
    rescue_with_handler(exception) || raise(exception)
  end

  def subscribe(list_id, email)
    CreateSend::Subscriber.add(@cs.auth_details, list_id, email, '', '', false)
  rescue Exception => exception
    rescue_with_handler(exception) || raise(exception)
  end

  def unsubscribe(list_id, email)
    CreateSend::Subscriber.new(@cs.auth_details, list_id, email).unsubscribe
  rescue Exception => exception
    rescue_with_handler(exception) || raise(exception)
  end

  def refresh_token(exception)
    access_token, expires_in, refresh_token = @cs.refresh_token
    @user.createsend_token = {access_token: access_token, refresh_token: refresh_token}
    @user.save
    @cs.clients
  end

end
