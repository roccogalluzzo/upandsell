class MailingListsService

  def initialize(provider, token)
    @provider = ("Providers::#{provider.classify}").constantize
    @provider_name = provider
    @token = token
  end

  def search(query)
    @provider.search_lists(@token, query)
  end

  def batch_subscribe(list_id)
    list = MailingList.find(list_id)
    @provider.batch_subscribe(@token, list.provider_list_id, list.emails)
  end

  def subscribe(list_id, email)
    @provider.subscribe(list_id, email)
  end

  def unsubscribe(list_id, email)
    @provider.unsubscribe(list_id, email)
  end
end

module  MLProvider

end