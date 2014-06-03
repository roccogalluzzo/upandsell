module S3File
  extend ActiveSupport::Concern

  @c =  Rails.configuration.aws

  @s3 = Fog::Storage.new({
   provider: 'AWS',
   aws_access_key_id: @c["access_key_id"],
   aws_secret_access_key: @c["secret_access_key"],
   region: 'eu-west-1'})

  def self.confirm(key)
    new_key = key.sub(/temp\//, '')
    @s3.copy_object(@c['bucket'], key, @c['bucket'], new_key)
    head = @s3.head_object(@c['bucket'], new_key).headers

    {key: new_key, info: { type: head["Content-Type"],
      size: head["Content-Length"]}}
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
end