# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Upandsell::Application.load_tasks

if ENV["CI_REPORTS"]
  require 'ci/reporter/rake/rspec'
  namespace :ci do
    task :all => ['ci:setup:rspec', 'spec']
  end
end