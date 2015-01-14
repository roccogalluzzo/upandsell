rails_root = Rails.root.join('config', 'split.yml')

split_config = YAML.load_file(rails_root)
Split.redis = split_config[Rails.env]