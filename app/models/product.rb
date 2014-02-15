class Product < ActiveRecord::Base
  has_many :payment
  belongs_to :customer
  validates_presence_of :name, :price, :file, :thumb

  Paperclip.interpolates('customer_id') do |attachment, style|
    attachment.instance.customer_id
  end

  has_attached_file :file,
  :url => 'download/p/:token',
  :path => ':rails_root/uploads/products/:customer_id/:id.:style.:extension',
  :storage => :s3,
  :s3_credentials => Proc.new{|a| a.instance.s3_credentials }

  has_attached_file :thumb, :styles => { :small => "72x72>" }

  monetize :price_cents, with_model_currency: :price_currency
  validates :price_cents, :numericality => {
    :greater_than => 0.50
  }
  def s3_credentials
    {:bucket => "up-sell-ms",
      :access_key_id => "AKIAI564OZSI6YDCGVFA",
      :secret_access_key => "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"}
  end
end
