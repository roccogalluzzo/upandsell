include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :subscription_invoice do
    user
    stripe_id 'stripe_id'
    stripe_customer_id 'stripe_customer_id'
    customer_country_code 'US'
    customer_vat_registered true
  end

  factory :subscription_invoice_finalized, parent: :subscription_invoice do
    finalized_at {Time.now}
  end

  factory :subscription_invoice_company_EU, parent: :subscription_invoice do
    customer_country_code 'GB'
    customer_vat_registered true
  end

  factory :subscription_invoice_company_IT, parent: :subscription_invoice do
    customer_country_code 'IT'
    customer_vat_registered true
  end
end
