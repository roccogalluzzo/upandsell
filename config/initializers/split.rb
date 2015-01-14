rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

split_config = YAML.load_file(rails_root + '/config/split.yml')
Split.redis = split_config[rails_env]