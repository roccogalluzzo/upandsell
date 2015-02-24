class WebhookOrder
  include Sidekiq::Worker
  sidekiq_options :retry => 5, :dead => false

  def perform(order_id)
    order = Order.find order_id
    user = order.user

    if !user.webhook_order_url.nil?
     response = RestClient.post user.webhook_order_url, order.to_json, content_type: :json, accept: :json
     if response != 200
      raise StandardError
    end
  end
end

end