class PreviewUploader < CarrierWave::Uploader::Base
 include CarrierWave::MiniMagick
 include CarrierWave::Processing::MiniMagick

 process resize_to_limit: [780, 500]
 process quality: 75
 process :strip

 version :thumb do
  process resize_to_fill: [80, 80]
end

 version :preview do
  process resize_to_fill: [120, 80]
end

storage :fog

def store_dir
  "uploads/products/images/#{mounted_as}/#{model.id}"
end

def default_url
  ActionController::Base.helpers.asset_path([version_name, "missing.png"].compact.join('_'))
end

 def extension_white_list
    %w(jpg jpeg gif png)
  end
end
