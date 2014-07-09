daemonize true
pidfile '/tmp/puma.pid'
bind 'unix:///tmp/upandsell.sock'

threads 1, 6
workers 1
stdout_redirect 'log/puma.log', 'log/puma_error.log', true
port        ENV['PORT']     || 3000
environment 'staging'

application_path = '/var/www/upandsell/current'
directory application_path
stdout_redirect "#{application_path}/log/puma-.stdout.log", "#{application_path}/log/puma-.stderr.log"

threads 0, 16
bind "unix://#{application_path}/tmp/sockets/#{railsenv}.socket"
on_worker_boot do
require "active_record"
cwd = File.dirname(__FILE__)+"/.."
ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || YAML.load_file("#{cwd}/config/database.yml")[ENV["RACK_ENV"]])
end

