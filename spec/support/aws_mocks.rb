Fog.mock!
@aws =  Rails.application.secrets.aws
FOG = ::Fog::Storage.new(
 provider: 'AWS',
 aws_access_key_id: @aws["access_key_id"],
 aws_secret_access_key: @aws["secret_access_key"]
 )

FOG.region = @aws["region"]
FOG.directories.create(key: @aws["bucket"])
