class Customer::PaymentsController < Customer::BaseController
def index
@payments= Customer.find(current_customer.id).payment
.where(completed: true).select('*').joins(:product)

end

end
