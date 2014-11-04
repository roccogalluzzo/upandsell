class Product < ActiveRecord::Base
  include S3File

  has_many :mailing_lists, through: :mailing_lists_products
  has_many :mailing_lists_products
  has_many :orders
  has_many :coupons
  belongs_to :user
  validates_presence_of :name, :price, :file_key
  serialize :file_info
  mount_uploader :preview, PreviewUploader
  monetize :price_cents, with_model_currency: :price_currency
  validates :price_cents, numericality: { greater_than: 49 }
  acts_as_paranoid
  before_create do
    self.slug = (Time.now.to_i + rand(1..1000)).to_s(36)
    self.file_info = {size: ''}
  end

  before_create do
    if self.file_key
      response = S3File.confirm(self.file_key)
      self.file_key = response[:key]
      self.file_info = response[:info]
    else
      return false
    end
  end
  before_save do
    if self.file_key_changed? && self.file_key_was != nil
      response = S3File.confirm(self.file_key)
      self.file_key = response[:key]
      self.file_info     = response[:info]
      S3File.delete(self.file_key_was)
    end
  end

before_destroy do
  S3File.delete(self.file_key)
end

def active_coupons
  self.coupons.active
end

def extension
  File.extname(self.file_key).delete('.')
end

def url
  S3File.url(self.file_key)
end

def file_name
  File.basename(self.file_key) if self.file_key
end

def file_size
  self.file_info[:size] || 0
end
def self.request(name)
  S3File.request(name)
end

def self.upload_from_url(name, url)
  S3File.upload_from_url(name, url)
end
end
