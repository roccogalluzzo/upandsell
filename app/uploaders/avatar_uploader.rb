class AvatarUploader < CarrierWave::Uploader::Base
 include CarrierWave::MiniMagick
 include CarrierWave::Processing::MiniMagick

 process resize_to_fit: [110, 110]
 process quality: 70
 process :strip


storage :fog

def store_dir
  "uploads/products/images/#{mounted_as}/#{model.id}"
end

def default_url
  ActionController::Base.helpers.asset_path('avatar_missing.png')
end

 def extension_white_list
    %w(jpg jpeg png)
  end
end
