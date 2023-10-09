# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

set :application, "qna"
set :repo_url, "git@github.com:killkih/qna.git"

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key', 'vendor/javascript/gist-embed.min.js'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

set :pty, false

after 'deploy:publishing', 'unicorn:restart'

