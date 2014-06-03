@aws =  Rails.configuration.aws

CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: @aws["access_key_id"],
    aws_secret_access_key: @aws["secret_access_key"],
    region: 'eu-west-1'
  }
  config.fog_public     = true
  config.fog_directory  = @aws["bucket"]
end

if ENV['RACK_ENV'] == 'test'

  Fog.mock!
  connection = ::Fog::Storage.new(
   provider: 'AWS',
   aws_access_key_id: @aws["access_key_id"],
   aws_secret_access_key: @aws["secret_access_key"],
   region: 'eu-west-1'
   )
  connection.directories.create(key: @aws["bucket"])
  connection.put_object( @aws["bucket"],
   "uploads/temp/products/1/test.exe", "test")
  connection.put_object( @aws["bucket"],
    "uploads/products/1/delete.exe", "test")
  connection.put_object( @aws["bucket"],
   "uploads/products/1/edit_test.exe", "test")
  connection.put_object( @aws["bucket"],
   "uploads/products/1/new_edit_test.exe", "test")
end