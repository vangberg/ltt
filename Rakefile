desc "run all tests"
task :test => ['test:unit', 'test:acceptance'] do
  nil
end

namespace :test do
  task :runtest do
    require 'rake/runtest'
  end

  desc "run unit tests"
  task :unit => :runtest do
    Rake.run_tests 'test/unit/*.rb', true
  end

  desc "run acceptance tests"
  task :acceptance => :runtest do
    Rake.run_tests 'test/acceptance/*.rb', true
  end
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
    ssh "cd #{APP_PATH} && test ! -d tmp && mkdir log"
  end
end
