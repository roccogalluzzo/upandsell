# Paymill config
paymill =  YAML.load_file(Rails.root.join("config/paymill.yml")).symbolize_keys
Billing::Paymill.config = paymill[Rails.env.to_sym].symbolize_keys
