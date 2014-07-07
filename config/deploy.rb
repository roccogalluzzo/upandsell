require 'mina/git'
require 'mina/bundler'
require 'mina/rails'
require 'mina/rbenv'
require 'mina/foreman'

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

set :foreman_app, 'upandsell_app'

task :environment do
  invoke :'rbenv:load'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

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
    invoke 'foreman:export'
    invoke :'rails:db_migrate'

    to :launch do
      invoke 'foreman:restart'
    end
  end
end


