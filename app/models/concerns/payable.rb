module Payable
 extend ActiveSupport::Concern
 include ActiveModel::Callbacks

 included do
  define_model_callbacks :pay
end

def pay(with, *args)

  run_callbacks :pay do
   api = get_gateway(with)
   api.pay(self, *args)
 end

end

private
def get_gateway(name)
 ("Payable::#{name.classify}").constantize
end
end