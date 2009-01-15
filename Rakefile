require 'cucumber/rake/task'
 
Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = "--format pretty --no-snippets"
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
