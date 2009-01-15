require 'cucumber/rake/task'
 
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty --no-snippets"
end

task :user do
  DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/production.db")
  DataMapper.auto_migrate!

  User.create(:login => login, :password => password)
end

# the lil' deployment script // http://gist.github.com/43233
 
APP_PATH = '/var/webapps/ltt'
APP_REPO = '/home/harry/git/ltt.git'
APP_SERVER = 'ak'
 
def ssh(command)
  `ssh #{APP_SERVER} sh -c '#{command.inspect}'`
end
 
desc 'deploy!'
task :deploy do
  ssh "cd #{APP_PATH} && git pull"
  ssh "touch #{APP_PATH}/tmp/restart.txt"
end

namespace :deploy do
  desc 'make directory and clone'
  task :setup do
    ssh "cd #{APP_PATH.sub(/[^\/]*$/,'')} && git clone #{APP_REPO}"
    ssh "cd #{APP_PATH} && test ! -d tmp && mkdir tmp"
  end
end
