pidfile '/tmp/puma.pid'
bind 'unix:///tmp/upandsell.sock'

threads 0, 6

stdout_redirect 'log/puma.log', 'log/puma_error.log', true
port        ENV['PORT']     || 3000
environment 'production'
stdout_redirect "/var/www/upandsell/current/log/puma-.stdout.log", "/var/www/upandsell/current/log/puma-.stderr.log"


on_worker_boot do
require "active_record"
cwd = File.dirname(__FILE__)+"/.."
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RACK_ENV"]])
end

