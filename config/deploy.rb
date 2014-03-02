set :application, 'up-sell'
set :repo_url, 'git@bitbucket.org:angelbit/up-sell.git'
set :user, "byterussian"
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :branch, 'master'
set :deploy_to, '/var/www/up-sell'
# set :scm, :git
set :deploy_via, :remote_cache
 set :format, :pretty
 set :log_level, :info
# set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
 set :keep_releases, 2
namespace :foreman do

  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
   on roles(:app) do
    run "cd #{current_path} && #{sudo} foreman export upstart /etc/init -a #{application} -u #{user} -l /var/#{application}/log"
  end
end
desc "Start the application services"
task :start do
 on roles(:app) do
  run "#{sudo} service #{application} start"
end
end
desc "Stop the application services"
task :stop do
 on roles(:app) do
  run "#{sudo} service #{application} stop"
end
end
desc "Restart the application services"
task :restart do
 on roles(:app) do
  run "#{sudo} service #{application} start || #{sudo} service #{application} restart"
end
end
end
namespace :deploy do
  task :restart do
   on roles(:app) do
    #foreman.export
    # on OS X the equivalent pid-finding command is `ps | grep '/puma' | head -n 1 | awk {'print $1'}`
    run "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || #{sudo} service #{application} restart"

    # foreman.restart # uncomment this (and comment line above) if we need to read changes to the procfile
  end
end
after :finishing, 'deploy:cleanup'

end