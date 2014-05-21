#require 'aws-sdk'
#Rails.configuration.aws = YAML.load_file(Rails.root.join("config/aws.yml")).symbolize_keys[Rails.env.to_sym]
#AWS.config(logger: Rails.logger)
#AWS.config(Rails.configuration.aws)