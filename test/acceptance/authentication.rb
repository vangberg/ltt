require File.dirname(__FILE__) + '/../helpers.rb'

class AuthenticationTest < Test::Unit::AcceptanceTestCase
  story <<-EOS
    As a user
    I want to be able to login
    So I can track time
  EOS

  scenario "valid credentials" do
    User.create(:login => 'Blakey', :password => 'Birdland')
    basic_auth 'Blakey', 'Birdland'

    visit '/'

    assert_have_selector "h1:contains('time tracker')"
    assert_have_selector "#user:contains('Blakey')"
  end

  scenario "invalid password" do
  end

  scenario "non-existing user" do
  end
end
