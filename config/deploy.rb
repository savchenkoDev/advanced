# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "advanced"
set :repo_url, "git@github.com:savchenkoDev/advanced.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/advanced"
set :deploy_user, "deployer"
set :format, :pretty

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"


# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

namespace :sphinx do
  desc "Restart Sphinx"
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake ts:configure"
          execute :bundle, "exec rake ts:index"
        end
      end
    end
  end
end

after "deploy:restart", "sphinx:restart"