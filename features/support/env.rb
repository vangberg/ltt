$0 = File.dirname(__FILE__) + '/../../app.rb'
require 'test/unit'
require 'webrat'
require 'webrat/sinatra'
require File.dirname(__FILE__) + '/../../app.rb'

Webrat.configure do |config|
  config.mode = :sinatra
end 

World do |world|
    Webrat::Methods.delegate_to_session :response_code, :response_body
    world.extend(Test::Unit::Assertions)
    world.extend(Webrat::Methods)
    world.extend(Webrat::Matchers)
    world
end
