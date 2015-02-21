# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Upandsell::Application.initialize!

if Rails.env.staging?
  Rails.logger = Le.new('8c6f300e-38a2-49ce-8b44-6b9a3abdf98b', debug: true)
else
  Rails.logger = Le.new('8c6f300e-38a2-49ce-8b44-6b9a3abdf98b')
end
