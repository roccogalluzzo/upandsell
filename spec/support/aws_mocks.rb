Fog.mock!
@aws =  Rails.configuration.aws
FOG = ::Fog::Storage.new(
 provider: 'AWS',
 aws_access_key_id: @aws["access_key_id"],
 aws_secret_access_key: @aws["secret_access_key"],
 region: 'eu-west-1'
 )
FOG.directories.create(key: @aws["bucket"])