require File.join(File.dirname(__FILE__), '..', 'helpers.rb')

class CreateEntryTest < Test::Unit::AcceptanceTestCase
  story <<-EOS
    As a user
    I want to add entries with preset duration
    So I can bill customers for work I forget to track
  EOS
  
  scenario "a user creates a 2 hour and 10 minute entry" do
    login!
    @user.projects.create(:name => 'Psychocandy')

    visit '/'
    within ".project:contains('Psychocandy') form:contains('Track time')" do
      fill_in 'duration', :with => '2h 10m'
      click_button
    end

    assert_have_selector ".project:contains('Psychocandy') .project-body[style='display: block']"
    assert_have_selector ".project:contains('Psychocandy') .entry:first:contains('2h10m')"
  end

  scenario "a user creates a 2 hour and 10 minute entry with description" do
    login!
    @user.projects.create(:name => 'Psychocandy')

    visit '/'
    within ".project:contains('Psychocandy') form:contains('Track time')" do
      fill_in 'duration', :with => '2h 10m'
      fill_in 'description', :with => 'Drums'
      click_button
    end

    assert_have_selector ".project:contains('Psychocandy') .project-body[style='display: block']"
    assert_have_selector ".project:contains('Psychocandy') .entry:first:contains('2h10m')"
    assert_have_selector ".project:contains('Psychocandy') .entry:first:contains('Drums')"
  end
end
