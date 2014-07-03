Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  secrets =  Rails.application.secrets
  provider :mailchimp, secrets.mailchimp['client_id'], secrets.mailchimp['client_secret'],
  provider_ignores_state: true

  provider :createsend, secrets.createsend['client_id'], secrets.createsend['client_secret'],
  scope: 'ManageLists',  provider_ignores_state: true

  provider :paymill, secrets.paymill['client_id'], secrets.paymill['client_secret'],
  scope: secrets.paymill['scope'], provider_ignores_state: true

end