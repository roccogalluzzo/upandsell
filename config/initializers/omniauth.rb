Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :mailchimp,  Rails.application.secrets.mailchimp['client_id'],
  Rails.application.secrets.mailchimp['client_secret']
  provider :createsend,  Rails.application.secrets.createsend['client_id'],
  Rails.application.secrets.createsend['client_secret'], scope: 'ManageLists'
end