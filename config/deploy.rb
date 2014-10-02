# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'websarafan'
set :repo_url, 'git@github.com:websarafan/websarafan.club.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/srv/websarafan'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml config/unicorn.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
set :default_env, { 
  path: "#{fetch(:rbenv_path)}/shims:/usr/local/bin:/usr/bin:/bin",
  home: '/home/app',
  rails_env: fetch(:stage).to_s
}

# Default value for keep_releases is 5
# set :keep_releases, 5

# default ssh options
set :ssh_options, {
  forward_agent: true
}

# rbenv configure
set :rbenv_type, :user
set :rbenv_ruby, '2.1.3'

namespace :deploy do

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, :sv, "-w 60", "start", "websarafan_rails" 
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, :sv, "-w 60", "stop", "websarafan_rails" 
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, :sv, "2", "websarafan_rails" 
    end
  end

  after :publishing, :restart
  after :finishing, "deploy:cleanup"
end
