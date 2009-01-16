require File.dirname(__FILE__) + '/../helpers.rb'

Webrat.configure do |config|
  config.mode = :sinatra
end

class Test::Unit::AcceptanceTestCase < Test::Unit::TestCase
  include Test::Storyteller
  include Webrat::Methods
  include Webrat::Matchers
  Webrat::Methods.delegate_to_session :response_code, :response_body

  before :each do
    setup_and_reset_database!
  end

  def setup_and_reset_database!
    DataMapper.setup(:default, "sqlite3::memory:")
    DataMapper.auto_migrate!
  end

  def login!
    @user = User.create(:login => 'Coltrane', :password => 'Olatunji')
    basic_auth 'Coltrane', 'Olatunji'
  end
end
