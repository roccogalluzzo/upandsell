pidfile '/tmp/puma.pid'
bind 'unix:///tmp/upandsell.sock'

threads 0, 8

stdout_redirect 'log/puma.log', 'log/puma_error.log', true
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'production'


on_worker_boot do
require "active_record"
cwd = File.dirname(__FILE__)+"/.."
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RACK_ENV"]])
end
