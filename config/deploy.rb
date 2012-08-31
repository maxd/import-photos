require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'

set :application, 'import-photos'

set :repository, 'git://github.com/maxd/import-photos.git'
set :scm, :git
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_exclude, %w(.git)

role :app, '192.168.1.100'
role :db, '192.168.1.100', :primary => true

set :user, 'closer'
set :use_sudo, false

set :deploy_to, "/home/closer/apps/#{application}"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system

set :normalize_asset_timestamps, false

task :link_configuration_files do
  run "ln -nfs #{shared_path}/config/database.yml #{current_release}/config/database.yml"
end

after 'deploy:update_code', 'link_configuration_files'
