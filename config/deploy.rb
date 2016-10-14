# config valid only for Capistrano 3.1
#lock '3.2.0'

set :application, 'upandsell'
set :repo_url, 'git@github.com:byterussian/upandsell.git'

# Default branch is :master
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deploy/apps/up-sell'
set :deploy_via, :remote_cache
# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle}

set :ssh_options, { forward_agent: true }
# Rbenv settings
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.2.5'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

fetch(:default_env).merge!(rails_env: :production, path: "/usr/local/bin:$PATH")
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2
before "deploy:starting", "deploy:set_env"
before 'deploy:updated', 'bower:install'
after "deploy:updated", "newrelic:notice_deployment"

namespace :deploy do

  desc 'set env'
  task :set_env do
    on roles(:app) do
      execute "source /etc/environment"
    end
  end

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
task :notify_rollbar do
  on roles(:app) do |h|
    revision = `git log -n 1 --pretty=format:"%H"`
    local_user = `whoami`
    rollbar_token = '0fbf1d3a866542708f030d210a7706e0'
    rails_env = fetch(:rails_env, 'production')
    execute "curl https://api.rollbar.com/api/1/deploy/ -F access_token=#{rollbar_token} -F environment=#{rails_env} -F revision=#{revision} -F local_username=#{local_user} >/dev/null 2>&1", :once => true
  end
end

after :deploy, 'notify_rollbar'
