Rails.configuration.aws = Rails.application.secrets.aws
AWS.config(logger: Rails.logger)
AWS.config(Rails.configuration.aws)