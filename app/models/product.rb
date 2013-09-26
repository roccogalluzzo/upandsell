class Product < ActiveRecord::Base
  belongs_to :customer, inverse_of: :product
  validates_presence_of :name, :price, :file, :thumb 

  has_attached_file :file
  has_attached_file :thumb

  monetize :price_cents
end
