class Product < ActiveRecord::Base
  has_many :payment
  belongs_to :customer
  validates_presence_of :name, :price, :file, :thumb 

  has_attached_file :file
  has_attached_file :thumb

  monetize :price_cents
end
