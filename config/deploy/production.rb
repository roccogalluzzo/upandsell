
server '213.171.184.160', user: 'deployer', roles: %w{web app db}, primary: true
set :rails_env, "production"
