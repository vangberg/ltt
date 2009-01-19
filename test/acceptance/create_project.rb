require File.join(File.dirname(__FILE__), '..', 'helpers.rb')

class CreateProjectTest < Test::Unit::AcceptanceTestCase
  story <<-EOS
    As a user
    I want to be able to create projects
    So I can bill the correct customers
  EOS

  scenario "a user can create a new project" do
    login!

    visit '/'
    fill_in 'name', :with => 'Night at Birdland'
    click_button 'Create'

    assert_have_selector ".project:contains('Night at Birdland') .project-body.visible"

    assert_have_selector ".project:first *:contains('Night at Birdland')"
    assert_have_selector ".project form[action$=night-at-birdland]"
  end
end
