# Paymill config
paymill =  YAML.load_file(Rails.root.join("config/paymill.yml")).symbolize_keys
Upandsell::Application.config.paymill = paymill[Rails.env.to_sym].symbolize_keys
