require 'rubygems'
require 'sinatra'

set     :raise_errors, true
set     :env,      :production
set     :public,   File.expand_path(File.dirname(__FILE__) + '/public')
set     :views,    File.expand_path(File.dirname(__FILE__) + '/views')
disable :run

log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'app.rb'

run Sinatra.application
