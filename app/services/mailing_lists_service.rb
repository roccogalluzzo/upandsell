class MailingListsService

  def initialize(provider, token)
    @provider = ("Providers::#{provider.classify}").constantize
    @provider_name = provider
    @token = token
  end

  def search(query)
    @provider.search_lists(@token, query)
  end

  def batch_subscribe(provider_list_id, emails)
    @provider.batch_subscribe(@token, provider_list_id, emails)
  end

  def subscribe(list_id, email)
    @provider.subscribe(@token, list_id, email)
  end

  def unsubscribe(list_id, email)
    @provider.unsubscribe(@token, list_id, email)
  end
end

module  MLProvider

end