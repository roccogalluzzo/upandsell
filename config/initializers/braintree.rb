    if Rails.env.production?
      Braintree::Configuration.environment = :live
    else
      Braintree::Configuration.environment = :sandbox
    end
