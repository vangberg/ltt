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
    within ".project:contains('Psychocandy')" do
      fill_in 'duration', :with => '2h 10m'
      click_button 'Create entry'
    end

    assert_have_selector ".project:contains('Psychocandy') .entry:first:contains('10m')"
  end
end
