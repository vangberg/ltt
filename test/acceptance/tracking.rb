require File.join(File.dirname(__FILE__), '..', 'helpers.rb')

class TrackingTest < Test::Unit::AcceptanceTestCase
  story <<-EOS
    As a user
    I want to track my time
    So I can bill customers appropriately
  EOS

  scenario "tracking a project shows it as being tracked" do
    login!
    @user.projects.create(:name => 'Blue Train')

    visit '/'
    within ".project:contains('Blue Train')" do
      click_button 'Track'
    end

    assert_have_selector "h1:contains('time tracker')"
    assert_have_selector ".project#tracking *:contains('Blue Train')"

    assert_have_no_selector ".project:contains('Blue Train') .entry"
  end

  scenario "while tracking don't show 'track' buttons" do
    login!
    @user.projects.create(:name => 'Safe As Milk')
    @user.projects.create(:name => 'Trout Mask Replica')

    visit '/'
    click_button_within ".project:contains('Safe As Milk')", 'Track'

    assert_have_no_selector "form[action*=track]"
  end

  scenario "when I stop tracking, no projects shows as being tracked" do
    login!
    @user.projects.create(:name => 'Unit Structures')

    visit '/'
    click_button_within ".project:contains('Unit Structures')", 'Track'
    click_button 'Stop'

    assert_have_no_selector '#tracking'
  end

  scenario "when I stop tracking an entry has been added to the project" do
    login!
    project = @user.projects.create(:name => 'Loveless')

    @user.track!(project)
    Entry.all.last.update_attributes(:created_at => Time.now - 10 * 60)

    visit '/'
    click_button 'Stop'

    assert_have_no_selector '#tracking'
    assert_have_selector ".project:contains('Loveless') .entry:first:contains('10')"
  end
end
