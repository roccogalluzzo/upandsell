PayPal::SDK.configure(Rails.application.secrets.paypal)
PayPal::SDK.logger = Rails.logger
