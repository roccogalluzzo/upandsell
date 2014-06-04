module Refundable
 extend ActiveSupport::Concern


 def refund
   gateway = get_gateway(self.gateway)
   api.refund(self, *args)
 end

 private
 def get_gateway(name)
  ("Gateways::#{name.classify}").constantize
 end
end