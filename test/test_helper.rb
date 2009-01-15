require 'rubygems'
require 'context'
require 'rr'
require 'sinatra'

disable :run
require 'app'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
