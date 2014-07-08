require 'mina/git'
require 'mina/bundler'
require 'mina/rails'
require 'mina/rbenv'

stage = ENV['to']
case stage
when 'staging'
  set :domain, "188.226.209.133"
  set :branch, 'staging'
when 'production'
  set :domain, "upandsell.me"
  set :branch, 'master'
else
  print_error "Please specify a stage. eg. mina deploy to=production"
  exit
end

set :rails_env, stage

set :user, 'deployer'
set :port, 4688

set :deploy_to, '/var/www/upandsell'
set :keep_releases, 2
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log', 'tmp']

set :repository, 'git@bitbucket.org:angelbit/up-sell.git'

set :foreman_app, 'upandsell'

task :environment do
  invoke :'rbenv:load'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/current"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/shared/config/secrets.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'

    to :launch do
     invoke 'foreman:export'
     invoke 'foreman:restart'
   end
 end
end

set_default :foreman_app,  lambda { application }
set_default :foreman_user, lambda { user }
set_default :foreman_log,  lambda { "#{deploy_to!}/#{shared_path}/log" }

namespace :foreman do
  desc 'Export the Procfile to Ubuntu upstart scripts'
  task :export do
    export_cmd = "rbenv sudo bundle exec foreman export upstart /etc/init -a #{foreman_app} -u #{foreman_user} -l #{foreman_log}"

    queue %{
      echo "-----> Exporting foreman procfile for #{foreman_app}"
      #{echo_cmd %[rbenv sudo sh -c 'cd #{deploy_to!}/#{current_path!}' ; #{export_cmd}]}
    }
  end

  desc "Start the application services"
  task :start do
    queue %{
      echo "-----> Starting #{foreman_app} services"
      #{echo_cmd %[rbenv sudo start #{foreman_app}]}
    }
  end

  desc "Stop the application services"
  task :stop do
    queue %{
      echo "-----> Stopping #{foreman_app} services"
      #{echo_cmd %[rbenv sudo stop #{foreman_app}]}
    }
  end

  desc "Restart the application services"
  task :restart do
    queue %{
      echo "-----> Restarting #{foreman_app} services"
      #{echo_cmd %[rbenv sudo restart #{foreman_app}]}
    }
  end
end

