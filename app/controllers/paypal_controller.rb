class PaypalController < ApplicationController
include PayPal::SDK::AdaptivePayments

def pay

  end

   private

    def api
      @api ||= API.new
    end
end
