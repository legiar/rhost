set :rails_env, "production"

set :application, "rhost"

set :repository, "git://github.com/legiar/rhost.git"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
#set :git_enable_submodules, 1

role :app, "mars.bpmonline.com"

set :user, "rhost"
set :use_sudo, false

set :app_dir, "/home/#{user}"

set :deploy_to, "#{app_dir}"

set :keep_releases, 10

after 'deploy:update_code', 'config:symlink_app_config'

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  after "deploy:setup" do
    run "mkdir -p #{deploy_to}/shared/pids && mkdir -p #{deploy_to}/shared/config && mkdir -p #{deploy_to}/shared/var"
  end

  after "deploy:update" do
    deploy::cleanup
  end
end

namespace :config do
  task :symlink_app_config do
    run "ln -sf #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
    run "ln -sf #{deploy_to}/shared/menu_helper #{current_release}/vendor/plugins/menu_helper"
  end
end

namespace :unicorn do
  task :start do
    #run "export PATH=/opt/ree/bin:$PATH && cd #{deploy_to}/current && unicorn_rails -c #{deploy_to}/current/config/unicorn.rb -e #{rails_env} -D"
    run "export PATH=/opt/ree/bin:$PATH && cd #{deploy_to}/current && unicorn_rails -c #{deploy_to}/current/config/unicorn.rb -D"
  end

  task :stop do
    run "kill -9 `cat #{deploy_to}/shared/pids/unicorn.pid`"
  end

  task :reload do
    run "kill -HUP `cat #{deploy_to}/shared/pids/unicorn.pid`"
  end

  task :restart do
    stop
    start
  end
end

