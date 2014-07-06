module MLProvider
  module Mailchimp

    def self.get_lists
    end

    def self.batch_subscribe(token, list_id, emails)
    # TODO transform emails
    gb = Gibbon::API.new(token)
    gb.lists.batch_subscribe(id: list_id,
     batch: emails,
     double_optin: false,
     update_existing: true
     )

  end

  def self.ubscribe(list_id, email)
    @provider.subscribe(list_id, email)
  end

  def self.unsubscribe(list_id, email)
    @provider.unsubscribe(list_id, email)
  end

end
end