require 'rubygems'
require 'sinatra'

set     :raise_errors, true
set     :env,      :production
disable :run

log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'app.rb'

run Sinatra.application
