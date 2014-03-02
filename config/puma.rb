deamonize true
pidfile '/tmp/pids/puma.pid'
state_path '/tmp/up-sell.stats'
bind 'unix:///tmp/up-sell.sock'

threads 0, 6
workers 1
activate_control_app 'unix:///var/run/pumactl.sock', { no_token: true }

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end