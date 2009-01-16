require File.dirname(__FILE__) + '/helpers.rb'

class EntriesTest < Test::Unit::AcceptanceTestCase
  story <<-EOS
    As a user
    I want to be able to delete entries
    So I'm now screwed if I fuck up and forget to stop tracking
  EOS

  scenario "a user can delete entries" do
    login!
    project = @user.projects.create(:name => "Native Songs")
    project.entries.create

    visit '/'
    click_button_within ".project:contains('Native Songs') .entry:first"

    assert_have_selector "h1:contains('time tracker')"
    assert_have_no_selector ".project:contains('Native Songs') .entry"
  end
end
