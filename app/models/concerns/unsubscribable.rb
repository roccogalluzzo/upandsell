module Unsubscribable
 extend ActiveSupport::Concern

 def unsubscribe_token(type)
  verifier =  ActiveSupport::MessageVerifier.new(
    URI::escape(Upandsell::Application.config.secret_key_base))
  token = verifier.generate("#{self.id}/#{type}")
  {user: self.id, type: type, signature: token}
end


def self.is_valid_token?(id, type, signature)
  self.find(id).unsubscribe_token(type)[:signature] == signature
end

def self.unsubscribe(id, type, signature)
  if self.is_valid_token?(id, type, signature)
    model = self.find id
    model.update_attribute type, false
  end
end
end