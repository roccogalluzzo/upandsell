module S3Service
  extend ActiveSupport::Concern
  @temp_key = "uploads/temp/products/%{id}/%{name}"
  @key =  "uploads/products/%{id}/%{name}"

  def self.upload(name)

    id = SecureRandom.uuid
    path = @temp_key % {id: id, name: name}
    file = AWS::S3.new.buckets[Rails.configuration.aws["bucket"]].presigned_post(
      key: path,
      success_action_redirect: '/',
      success_action_status: 201,
      metadata: {id: id})

   return  {id: id, status: 200, fields: file.fields}
  end

  def self.upload_confirm(id, name)
    bucket = AWS::S3.new.buckets[Rails.configuration.aws["bucket"]]

    old_obj = bucket.objects[@temp_key % {id: id, name: name}]
    Rails.logger.info @temp_key % {id: id, name: name}
    new_obj = old_obj.move_to(@key % {id: id, name: name})

    new_obj.exists?
  end

end