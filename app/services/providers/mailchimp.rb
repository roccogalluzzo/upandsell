module Providers::Mailchimp

  def self.search_lists(token, query)
    gb = Gibbon::API.new(token)
    gb.lists.list({
      filters: {list_name: query},
      limit: 5
      })['data']
  end

  def self.batch_subscribe(token, mailchimp_list_id, emails)
    batch = []
    emails.each do |email|
      batch << {email: {email: email}}
    end
    gb = Gibbon::API.new(token)
    gb.timeout = 300
    gb.lists.batch_subscribe(id: mailchimp_list_id,
     batch: batch,
     double_optin: false,
     update_existing: true
     )
  end

  def self.subscribe(token, list_id, email)
    gb = Gibbon::API.new(token, {throws_exceptions: false})
    gb.lists.subscribe({id: list_id,
      email: {email: email},
      double_optin: false
      })
  end

  def self.unsubscribe(token, list_id, email)
    gb = Gibbon::API.new(token, {throws_exceptions: false})
    gb.lists.unsubscribe(id: list_id,
     email: {email: email},
     delete_member: true,
     send_notify: false)
  end

end

