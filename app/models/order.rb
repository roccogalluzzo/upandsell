class Order
  extend  ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include API

  attr_accessor :id, :product_id, :user_id, :email, :gateway, :gateway_token,
  :payment_details, :amount, :currency, :amount_base, :status, :n_downloads,
  :cancelled_at, :closed_at, :buyer_accepts_marketing, :token


  def initialize(params = {})
    params.each { |key, value| send "#{key}=", value }
  end

  def find(id)
    response = API.api.get("orders/#{id}").body
    update_attributes(response)
    self
  end

  def find_by(att)
    response = API.api.get('orders', att).body[0].symbolize_keys
    update_attributes(response)
    self
  end

  def create
   response = API.api.post('orders', attributes).body.symbolize_keys
   update_attributes(response)
   true
 end

 def update
  response = API.api.put("orders/#{@id}", attributes).body.symbolize_keys
  update_attributes(response)
  true
end

def destroy
 API.api.delete("orders/#{@id}")
end

def refund
  API.api.put("orders/#{@id}/refunded")
end


def update_attributes(attrs)
 attrs.each { |key, value| send "#{key}=", value }
end

def self.user(user_id, page = 1, per_page = 5)
  if page.blank?
    page = 1
  end
  response  = API.api.get("orders/user/#{user_id}", page: page, per_page: per_page)
  response.body.map { |x| x.symbolize_keys }
end

def persisted?
  true unless  @id.blank?
end

def attributes

  {product_id: @product_id, user_id: @user_id, email: @email, gateway: @gateway,
    gateway_token: @gateway_token, amount: @amount, currency: @currency,
    payment_details: @payment_details, status: @status, n_downloads: @n_downloads,
    ip: @ip, buyer_accepts_marketing: @buyer_accepts_marketing}
  end

  #after_save :update_metrics

#   def unsubscribe_token
#     verifier =  ActiveSupport::MessageVerifier.new(
#       URI::escape(Upandsell::Application.config.secret_key_base))
#     token = verifier.generate("#{self.id}")
#     {order: self.id, signature: token}
#   end


#   def self.is_valid_token?(id, signature)
#     Order.find(id).unsubscribe_token[:signature] == signature
#   end

#   def self.unsubscribe(order_id, signature)
#     if self.is_valid_token?(order_id, signature)
#       user = self.find order_id
#       user.update_attribute :email_subscription, false
#     end
#   end

#   private
#   def update_metrics
#     if self.status == 'completed' && self.status_was != 'completed'
#      user = User.find(self.product.user_id)
#      UserMailer.delay.bought_email(user, self)
#      if user.email_after_sale
#        UserMailer.delay.sold_email(user, self)
#      end
#    end
#    if self.status == 'refunded' && self.status_was == 'completed'
#     UserMailer.delay.refund_email(user, self)
#   end
# end

end