# config valid only for Capistrano 3.1
#lock '3.2.0'

set :application, 'upandsell'
set :repo_url, 'git@bitbucket.org:angelbit/up-sell.git'

# Default branch is :master
ask :branch, :staging #proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/upandsell'

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle}

# Rbenv settings
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

# Foreman Settings
set :foreman_sudo, 'rbenv sudo'
set :foreman_upstart_path, '/etc/init/'
set :foreman_options, {log: "#{shared_path}/log"}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do

      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after "deploy:update", "foreman:export"
  after "deploy:update", "foreman:restart"
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  end
  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, :roles => :app do
      run "cd /var/www/upandsell && rbenv sudo bundle exec foreman export upstart /etc/init -a app -u deploye
      -l /var/www/upandsell/shared/log"
    end

    desc "Start the application services"
    task :start, :roles => :app do
      sudo "sudo start app"
    end

    desc "Stop the application services"
    task :stop, :roles => :app do
      sudo "sudo stop app"
    end

    desc "Restart the application services"
    task :restart, :roles => :app do
      run "sudo start app || sudo restart app"
    end
  end

