require 'rubygems'
require 'test/unit'
require 'context'
require 'storyteller'
require 'webrat/sinatra'
require 'rr'
require 'app'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
