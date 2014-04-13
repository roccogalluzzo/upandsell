set :application, 'up-sell'
set :repo_url, 'git@bitbucket.org:angelbit/up-sell.git'
set :user, "byterussian"

set :branch, 'master'
set :deploy_to, '/var/www/up-sell'
set :scm, :git
set :deploy_via, :remote_cache
set :format, :pretty
set :log_level, :info


set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 2

namespace :deploy do
  task :restart do
   on roles(:app) do
     execute "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'}))"
   end
 end
 after :finishing, 'deploy:cleanup'
 after :finishing, 'deploy:restart'
end