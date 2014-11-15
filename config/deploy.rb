require 'bundler/capistrano'

set :domain, "54.148.21.147"
set :user, "neovision"
set :password, "ne0v1$10n"
set :application, "neorest"
set :repository,  "git@github.com:jhantooshaw/neorest.git"
set :rails_env, "production"
set :scm, :git
#set :scm_username, "jhantooshaw"
set :deploy_to, "/home/neovision/rails_app/#{application}" 
set :use_sudo, false
set :chmod755, "app config db db/* log/production.log vendor script script/* public"
set :keep_releases, 5 

#default_run_options[:pty] = true
#ssh_options[:keys] = %w(~/.ssh/id_rsa)
#ssh_options[:forward_agent] = true
role :app, domain
role :web, domain
role :db,  domain, :primary => true

after "deploy:restart", "deploy:cleanup"
after "deploy:finalize_update", "deploy:assets:precompile"
after "deploy", "deploy:restart"

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if releases.length <= 1 || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
  
  desc "Restart passenger app"
  task :restart do
    run "ln -s #{shared_path}/assets #{current_path}/public/assets"
    run "touch #{File.join(current_path, 'tmp', 'restart.txt') }"
  end  
  
  
end

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end