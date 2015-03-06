class Product < ActiveRecord::Base
  include Uploadable

  has_many :mailing_lists, through: :mailing_lists_products
  has_many :mailing_lists_products
  has_many :orders
  has_many :coupons
  belongs_to :user
  validates_presence_of :name, :price
  mount_uploader :preview, PreviewUploader
  monetize :price_cents, with_model_currency: :price_currency
  validates :price_cents, numericality: { greater_than: 49 }
  acts_as_paranoid

  before_create do
    self.slug = (Time.now.to_i + rand(1..10000)).to_s(36)
  end
end
