module Uploadable
  extend ActiveSupport::Concern

  included do
    validates :file_key, presence: true
    serialize :file_info
    before_save :check_file_location
    before_destroy :delete_file
  end

  def check_file_location
    return false unless self.file_key
    finalize_file_upload if self.file_key_changed?
    UploadService.new.delete(self.file_key_was) unless self.file_key_was.nil?
  end

  def extension
    File.extname(self.file_key).delete('.')
  end

  def url
    UploadService.new.url(self.file_key)
  end

  def file_name
    File.basename(self.file_key) if self.file_key
  end

  def file_size
    return 0 if file_info.nil?
    self.file_info[:size] || 0
  end

  def delete_file
    UploadService.new.delete(self.file_key)
  end

  module ClassMethods
    def request(name)
      UploadService.new.request(temp_store_key(name))
    end

    def upload_from_url(name, url)
      UploadService.new.upload_from_url(temp_store_key(name), url)
    end

    private
    def temp_store_key(name)
      s_name = CarrierWave::SanitizedFile.new(name).filename
      "uploads/temp/products/#{guid}/#{s_name}"
    end

    private
    def guid
      UUIDTools::UUID.random_create
    end
  end

  private
  def finalize_file_upload
    response = UploadService.new.confirm(self.file_key)
    self.file_key = response[:key]
    self.file_info = response[:info]
  end
end
