require 'rubygems'
require 'sinatra'

set     :env,      :production
disable :run

require 'app.rb'

run Sinatra.application
