require 'open-uri'

module S3File
  extend ActiveSupport::Concern

  @c =  Rails.application.secrets.aws

  @s3 = Fog::Storage.new({
   provider: 'AWS',
   aws_access_key_id: @c["access_key_id"],
   aws_secret_access_key: @c["secret_access_key"],
   region: @c['region']})

  def self.confirm(key)
    new_key = key.sub(/temp\//, '')
    if @s3.copy_object(@c['bucket'], key, @c['bucket'], new_key).status == 200
     head = @s3.head_object(@c['bucket'], new_key).headers
     return {key: new_key, info: { type: head["Content-Type"],
      size: head["Content-Length"]}}
    end
    false
  end

  def self.delete(key)
    @s3.delete_object(@c['bucket'], key)
  end

  def self.url(key)
    @s3.directories.new(key: @c['bucket']).files.new(key: key).url(Time.now + 3000)
  end

  def self.request(name)

   file = ProductUploader.new
   file.success_action_redirect = '/'
   file.temp_store_key(name)

   { key: file.key,
    "AWSAccessKeyId" => file.aws_access_key_id,
    acl: file.acl,
    success_action_redirect: file.success_action_redirect,
    policy: file.policy,
    signature: file.signature}
  end

  def self.upload_from_url(name, url)
   file = ProductUploader.new
   file.success_action_redirect = '/'
   key = file.temp_store_key(name)

   open(url) {|f|
    file =  @s3.directories.new(key: @c['bucket']).files.create({
      key: key,
      body: f.read,
      public: false,
      })
    if file.save
      return { file_key: file.key}
    end
  }
  return false
end
end