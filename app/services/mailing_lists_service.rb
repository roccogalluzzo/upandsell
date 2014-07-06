class MailingListsService

  def initialize(provider, token)
    @provider = ("MLProvider::#{provider.classify}").constantize
    @provider_name = provider
    @token = token
  end

  def get_lists
  end

  def batch_subscribe(provider_list_id, emails)
   @provider.batch_subscribe(@token, provider_list_id, emails)
 end

 def subscribe(list_id, email)
  @provider.subscribe(list_id, email)
end

def unsubscribe(list_id, email)
  @provider.unsubscribe(list_id, email)
end
end