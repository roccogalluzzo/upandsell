require 'rails_helper'

describe "Billing Events" do

  describe "charge.failed" do

    xit "is successful" do
      post '/_billing_events', id: 'evt_customer_created'
      expect(response.code).to eq "200"
      # Additional expectations...
    end
  end
end