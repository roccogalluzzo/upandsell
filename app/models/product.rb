require 'modules/base52'
class Product < ActiveRecord::Base

  has_many :payment
  belongs_to :customer
  validates_presence_of :name, :price, :uuid, :file_file_name

  Paperclip.interpolates :uuid do |attachment, style|
    attachment.instance.uuid.to_s
  end
  Paperclip.interpolates :b_customer_id do |attachment, style|
    Base52.encode(attachment.instance.customer_id).to_s
  end
  before_save :set_upload_attributes
  after_destroy :clean_files

  has_attached_file :thumb, :styles => { :small => "72x72>" },
  :storage => :s3,
  :s3_credentials => "#{Rails.root}/config/aws.yml",
  :path => 'uploads/products/images/:uuid/:id.:style.:extension',
  :s3_permissions => :public_read

  validates_attachment_content_type :thumb, :content_type => /\Aimage/

  monetize :price_cents, with_model_currency: :price_currency
  validates :price_cents, :numericality => {
    :greater_than => 0.50
  }

  def clean_files
    self.delete_file(self.customer_id, self.uuid, self.file_file_name)
  end
  def extension
     File.extname(self.file_file_name).delete('.')
  end
  def expiring_url(time = 3600)
    s3 = AWS::S3.new
    tries ||= 5
    direct_upload_url_data = "uploads/products/#{Base52.encode(self.customer_id)}/#{self.uuid}/#{self.file_file_name}"
    s3.buckets[Rails.configuration.aws["bucket"]]
    .objects[direct_upload_url_data].url_for(:read, expires: time, secure: true).to_s
  rescue AWS::S3::Errors::NoSuchKey => e
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
    end
  end

  # Set attachment attributes from the direct upload
  # @note Retry logic handles S3 "eventual consistency" lag.
  def set_upload_attributes
    tries ||= 5
    if self.uuid_changed?
      direct_upload_url_data = "uploads/products/#{Base52.encode(self.customer_id)}/#{self.uuid}/#{self.file_file_name}"
      s3 = AWS::S3.new
      direct_upload_head = s3.buckets[Rails.configuration.aws["bucket"]].objects[direct_upload_url_data].head
      self.file_file_name     = direct_upload_head.meta["file_name"]
      self.file_file_size     = direct_upload_head.content_length
      self.file_content_type  = direct_upload_head.content_type
      self.file_updated_at    = direct_upload_head.last_modified
    end
    if self.uuid_was
   #delete old file
   self.delete_file(self.customer_id, self.uuid_was, self.file_file_name_was)
 end
end
 def delete_file(customer_id, uuid, file_file_name)
  direct_upload_url_data = "uploads/products/#{Base52.encode(customer_id)}/#{uuid}/#{file_file_name}"
  s3 = AWS::S3.new
  direct_upload_head = s3.buckets[Rails.configuration.aws["bucket"]].objects[direct_upload_url_data].delete

rescue AWS::S3::Errors::NoSuchKey => e
  tries -= 1
  if tries > 0
    sleep(3)
    retry
  else
    false
  end

end
end
