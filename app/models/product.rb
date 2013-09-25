class Product < ActiveRecord::Base
  
  validates :name, presence: true

  has_attached_file :file
  has_attached_file :thumb
end
