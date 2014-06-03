class PreviewUploader < CarrierWave::Uploader::Base
 include CarrierWave::MiniMagick
 include CarrierWave::Processing::MiniMagick

 process resize_to_fit: [800, 800]
 process quality: 75
 process :strip

 version :thumb do
  process resize_to_fill: [72, 60]
end

storage :fog

def store_dir
  "uploads/products/images/#{mounted_as}/#{model.id}"
end

def default_url
  ActionController::Base.helpers.asset_path('missing.png')
end

end