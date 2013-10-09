class Customer::PaymentsController < Customer::BaseController
def index
@payments= Customer.find(current_customer.id).payment
end

end
