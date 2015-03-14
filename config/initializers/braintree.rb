if Rails.env.production?
  Braintree::Configuration.environment = :production
else
  Braintree::Configuration.environment = :sandbox
end
