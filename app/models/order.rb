class Order < ActiveRecord::Base

 belongs_to :product
 monetize :amount_cents
 monetize :amount_base_cents

 before_create { self.token = SecureRandom.urlsafe_base64(16)}
 before_create {self.amount_base = self.amount.exchange_to('EUR')}
 after_save :update_metrics

 def unsubscribe_token(type)
  verifier =  ActiveSupport::MessageVerifier.new(Upandsell::Application.config.secret_key_base)
  token = verifier.generate("#{self.id}")
  {order: self.id, signature: token}
end


def self.is_valid_token?(id, signature)
  verifier =  ActiveSupport::MessageVerifier.new(Upandsell::Application.config.secret_key_base)
  new_s = verifier.generate("#{id}")
  new_s == signature
end

def self.unsubscribe(order_id, signature)
  if self.is_valid_token?(order_id, signature)
    user = self.find order_id
    user.update_attribute :email_subscription, false
  end
end

private
def update_metrics
  if self.status == 'completed' && self.status_was != 'completed'
   user = User.find(self.product.user_id)
   UserMailer.delay.bought_email(user, self)
   UserMailer.delay.sold_email(user, self)
 end
end

end