class Product < ActiveRecord::Base
  has_many :payment
  belongs_to :customer
  validates_presence_of :name, :price, :file, :thumb

  has_attached_file :file
  has_attached_file :thumb, :styles => { :small => "72x72>" }

  monetize :price_cents, with_model_currency: :price_currency
  validates :price_cents, :numericality => {
    :greater_than => 0.50
  }
end
