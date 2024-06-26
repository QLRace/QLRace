# frozen_string_literal: true

require "dotenv/load"
require "mina/rails"
require "mina/git"
require "mina/rbenv" # for rbenv support. (https://rbenv.org)

qlrace_domain = ENV.fetch("QLRACE_DEPLOY_DOMAIN")
qlrace_path = ENV.fetch("QLRACE_DEPLOY_PATH")
qlrace_username = ENV.fetch("QLRACE_DEPLOY_USERNAME")

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, "qlrace"
set :domain, qlrace_domain
set :deploy_to, qlrace_path
set :repository, "https://github.com/QLRace/QLRace.git"
set :branch, "master"

# Optional settings:
set :user, qlrace_username # Username in the server to SSH to.
set :port, nil             # SSH port number. Unset to use port from ssh_config.
# set :forward_agent, true  # SSH forward_agent.

set :bundle_options, -> { "" }

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  invoke :"rbenv:load"
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  ruby_version = File.read(".ruby-version").strip
  command "rbenv install #{ruby_version} --skip-existing"
  command "#{fetch(:bundle_bin)} config set deployment 'true'"
  command "#{fetch(:bundle_bin)} config set path '#{fetch(:bundle_path)}'"
  command "#{fetch(:bundle_bin)} config set without '#{fetch(:bundle_withouts)}'"
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :"git:clone"
    command "rbenv install --skip-existing"
    invoke :"deploy:link_shared_paths"
    invoke :"bundle:install"
    invoke :"rails:db_migrate"
    invoke :"rails:assets_precompile"
    invoke :"deploy:cleanup"

    on :launch do
      in_path(fetch(:current_path)) do
        command "#{fetch(:bundle_prefix)} pumactl restart"
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
