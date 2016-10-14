
server '5.144.174.48', user: 'deploy', roles: %w{web app db}, primary: true

set :rails_env, 'staging'
