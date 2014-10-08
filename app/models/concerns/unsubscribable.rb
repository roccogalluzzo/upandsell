module Unsubscribable
  extend ActiveSupport::Concern

  def unsubscribe_token(type)
    verifier =  ActiveSupport::MessageVerifier.new(URI::escape(Rails.application.secrets.secret_key_base))
    token = verifier.generate("#{self.id}/#{type}")
    {user: self.id, type: type, signature: token}
  end


  def self.is_valid_token?(id, type, signature)
    Order.find(id).unsubscribe_token(type)[:signature] == signature
  end


  module ClassMethods
    def unsubscribe(id, type, signature)
      if Unsubscribable.is_valid_token?(id, type, signature)
        model = self.find(id)
        model.update_attribute(type, false)
      end
    end
  end
end