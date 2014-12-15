# config valid only for Capistrano 3.1
#lock '3.2.0'

set :application, 'upandsell'
set :repo_url, 'git@bitbucket.org:angelbit/up-sell.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/upandsell'
set :deploy_via, :remote_cache
# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle}

set :ssh_options, { forward_agent: true }
# Rbenv settings
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo service puma restart || sudo service puma start"
      execute "sudo service sidekiq restart || sudo service sidekiq start"
    end
  end

  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
