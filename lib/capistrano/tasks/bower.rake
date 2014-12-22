desc 'Install bower'
namespace :bower do
  task :install do
    on roles(:all) do
      within release_path do
        execute :rake, 'bower:install'
      end
    end
  end
end
