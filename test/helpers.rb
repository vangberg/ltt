require 'rubygems'
require 'test/unit'
require 'context'
require 'storyteller'
require 'webrat/sinatra'
require 'rr'
require 'app'

require File.dirname(__FILE__)  / 'acceptance' / 'helpers'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end
