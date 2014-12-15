
server '178.62.178.149', user: 'deploy', roles: %w{web app db}, primary: true

set :rails_env, 'staging'
