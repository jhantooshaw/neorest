set :application, "yapfish"
set :domain, "107.131.33.66" #ssh van@107.131.33.66   Yapfish7735
set :user, "van"
set :password, "Yapfish7735"
set :scm_username, "circar"
set :rails_env, "staging"
set :scm, :git
set :repository, "git@ezwebguru.unfuddle.com:ezwebguru/yapfish.git"
#set :deploy_to, "/home/van/rails_app/#{application}"
set :deploy_to, "/var/www/rails/#{application}" # cd /var/www/rails/yapfish/current/
set :use_sudo, false
set :chmod755, "app config db db/* log/staging.log vendor script script/* public"
set :keep_releases, 5 # number of deployed releases to keep
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
default_run_options[:pty] = true
ssh_options[:keys] = %w(~/.ssh/id_rsa)
ssh_options[:forward_agent] = true
role :app, domain
role :web, domain
role :db,  domain, :primary => true
namespace :deploy do
  task :restart, :roles => :app do
    # run "cp #{current_path}/config/server.database.yml #{current_path}/config/database.yml"
    run "cp #{release_path}/config/server.database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/photos #{release_path}/public/photos"
  #  run "ln -s #{shared_path}/Gemfile.lock #{release_path}/Gemfile.lock"
    #run "cd #{current_path} && rake assets:precompile RAILS_ENV=#{rails_env}"
    # run "cd #{release_path} && rake assets:clean && rake assets:precompile RAILS_ENV=staging"
    run "cd #{release_path} && chmod -R 755 #{chmod755}"
    #run "cd #{current_path} && bundle install --path vendor/bundle"
    run "touch #{current_path}/tmp/restart.txt"
    #run "cd ~ && cd /var/www/rails/yapfish/current && bundle exec rake assets:clean && bundle exec rake assets:precompile && touch tmp/restart.txt"
  end
end
after "deploy", "deploy:cleanup"
#after 'deploy:update_code' do
#  run "cd #{release_path}; rake assets:clean"
#  run "cd #{release_path}; rake assets:precompile RAILS_ENV=#{rails_env}"
#end
