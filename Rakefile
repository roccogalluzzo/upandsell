require 'ci/reporter/rake/rspec'

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Upandsell::Application.load_tasks

namespace :ci do
  task :all => ['ci:setup:rspec', 'rspec']
end
