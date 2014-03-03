daemonize true
pidfile '/tmp/puma.pid'
bind 'unix:///tmp/up-sell.sock'

threads 0, 6

environment 'production'
on_worker_boot do
require "active_record"
cwd = File.dirname(__FILE__)+"/.."
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RACK_ENV"]])
end