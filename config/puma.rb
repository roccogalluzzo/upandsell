daemonize true
pidfile '/tmp/puma.pid'
bind 'unix:///tmp/upandsell.sock'

threads 1, 6
workers 2

port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'staging'

on_worker_boot do
require "active_record"
cwd = File.dirname(__FILE__)+"/.."
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RACK_ENV"]])
end
