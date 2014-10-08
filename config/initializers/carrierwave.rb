@aws =  Rails.application.secrets.aws

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: @aws["access_key_id"],
    aws_secret_access_key: @aws["secret_access_key"],
    region: @aws["region"]
  }
  config.fog_public     = true
  config.fog_directory  = @aws["bucket"]
end