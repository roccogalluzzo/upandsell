class Providers::Createsend
  include ActiveSupport::Rescuable

  rescue_from CreateSend::ExpiredOAuthToken do |ex|
    access_token, expires_in, refresh_token = @cs.refresh_token
    @user.createsend_token = {access_token: access_token, refresh_token: refresh_token}
    @user.save
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
    CreateSend::Subscriber.import(@cs.auth_details, list_id)
  end

  def subscribe(list_id, email)
  end

  def self.unsubscribe(list_id, email)
  end

  def self.create_list(user_id, list_name)
    cs = get_api(user_id)
    list = CreateSend::List.create(cs.auth_details, cs.clients.first.ClientID, list_name,
      'https://upandsell.me/', false, 'https://upandsell.me/')
    byebug
    list
  end







end
