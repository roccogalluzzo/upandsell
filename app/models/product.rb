class Product < ActiveRecord::Base
  include Payable

  has_many :orders
  belongs_to :user
  validates_presence_of :name, :price, :uuid, :file_file_name

  before_create { self.slug = (Time.now.to_i + rand(1..100)).to_s(36)}

  Paperclip.interpolates :user_id do |attachment, style|
    attachment.instance.user_id.to_s
  end

  before_save :set_upload_attributes
  after_destroy :clean_files

  has_attached_file :thumb, styles: { small: "72x60" },
  convert_options: {
    thumb: "-quality 75 -strip -thumbnail" },
    storage: :s3,
    s3_protocol: 'https',
    s3_credentials: "#{Rails.root}/config/aws.yml",
    path: 'uploads/products/images/:user_id/:id.:style.:extension',
    s3_permissions: :public_read,
    :default_url => ActionController::Base.helpers.asset_path('missing.png')

    validates_attachment_content_type :thumb, :content_type => /\Aimage/

    monetize :price_cents, with_model_currency: :price_currency
    validates :price_cents, :numericality => {
      :greater_than => 0.50
    }

    def clean_files
      self.delete_file(self.uuid, self.file_file_name)
    end

    def extension
     File.extname(self.file_file_name).delete('.')
   end

   def expiring_url(time = 3600)
    s3 = AWS::S3.new
    tries ||= 5
    direct_upload_url_data = "uploads/products/#{self.uuid}/#{self.file_file_name}"
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

  def set_upload_attributes
    tries ||= 5
    if self.uuid_changed?
      direct_upload_url_data = "uploads/products/#{self.uuid}/#{self.file_file_name}"
      s3 = AWS::S3.new
      direct_upload_head = s3.buckets[Rails.configuration.aws["bucket"]].objects[direct_upload_url_data].head
      self.file_file_size     = direct_upload_head.content_length
      self.file_content_type  = direct_upload_head.content_type
      self.file_updated_at    = direct_upload_head.last_modified
    end
    if self.uuid_was != self.uuid
   #delete old file
   self.delete_file(self.uuid_was, self.file_file_name_was)
 end
end

def delete_file(uuid, file_file_name)
  direct_upload_url_data = "uploads/products/#{uuid}/#{file_file_name}"
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
