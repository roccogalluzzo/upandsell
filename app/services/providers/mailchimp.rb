module Providers::Mailchimp

  def self.search_lists(token, query)
    gb = Gibbon::API.new(token)
    gb.lists.list({
      filters: {list_name: query},
      limit: 5
      })['data']
  end

  def self.batch_subscribe(token, mailchimp_list_id, emails)
      # TODO transform emails
      gb = Gibbon::API.new(token)
      gb.timeout = 300
      gb.lists.batch_subscribe(id: mailchimp_list_id,
       batch: emails,
       double_optin: false,
       update_existing: true
       )
byebug
    end

    def self.ubscribe(token, list_id, email)
      gb = Gibbon::API.new(token)
      gb.lists.subscribe({id: list_id,
        email: {email: email},
        double_optin: false
        })
    end

    def self.unsubscribe(token, list_id, email)
      gb = Gibbon::API.new(token)
      gb.lists.unsubscribe(id: list_id,
       email: {email: "user_email"},
       delete_member: true,
       send_notify: true)
    end

  end

