class ProductUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  storage :fog

  def temp_store_key(name)
    s_name = CarrierWave::SanitizedFile.new(name).filename
    self.key = "uploads/temp/products/#{guid}/#{s_name}"
  end

  def store_key(key)
   key.sub(/temp\//, '')
 end

 def to_fog(key)
   ProductFile.new(self, self, key)

 end

 def initialize(*)
  super
  self.fog_public = false
end
end

class ProductFile < CarrierWave::Storage::Fog::File
  attr_accessor :path
end