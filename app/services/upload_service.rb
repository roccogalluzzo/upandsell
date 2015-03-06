class UploadService

  def initialize
    @c = Rails.application.secrets.aws
    @s3 = Fog::Storage.new({
     provider: 'AWS',
     aws_access_key_id: @c["access_key_id"],
     aws_secret_access_key: @c["secret_access_key"],
     region: @c['region']})
  end

  def confirm(key)
    new_key = key.sub(/temp\//, '')
    if @s3.copy_object(@c['bucket'], key, @c['bucket'], new_key).status == 200
      head = @s3.head_object(@c['bucket'], new_key).headers
      return {key: new_key, info: { type: head["Content-Type"],
        size: head["Content-Length"]}}
      end
    rescue  Excon::Errors::NotFound
      false
    end

    def delete(key)
      response = @s3.delete_object(@c['bucket'], key)
      return true if response.status == 204
    end

    def url(key)
      @s3.directories.new(key: @c['bucket']).files.new(key: key).url(Time.now + 3000)
    end

    def request(name)
     file = @s3.post_object_hidden_fields({'policy' => upload_policy(name), 'key' => name, 'acl' => 'private'})
     file
   end

   def upload_from_url(key, url)
     open(url) do |f|
       file = @s3.directories.new(key: @c['bucket']).files.create({
         key: key,
         body: f.read,
         public: false,})
       if file.save
         return { file_key: file.key}
       end
     end
   rescue OpenURI::HTTPError => error
    false
  end

  private
  def upload_policy(file_key)
    {'expiration' => 1.hour.from_now.iso8601,
      'conditions' => [
        {'bucket' => @c['bucket']},
        {'acl' => 'private'},
        {'key' => file_key}
      ]
    }
  end
end
