require File.join(File.dirname(__FILE__), '..', 'helpers.rb')

class EditProjectTest < Test::Unit::AcceptanceTestCase
  story <<-EOS
    As a user
    I want to be able to edit project information
    So I can keep it current & up to date & stuff
  EOS

  scenario "a user changes the alias" do
    login!
    @user.projects.create(:name => "This Year's Model")
    @user.projects.create(:name => "My Aim Is True")

    visit '/'
    within ".project:contains('My Aim Is True') form:contains('Change alias')" do
      fill_in 'project[short_url]', :with => 'aim'
      click_button
    end

    assert_have_selector ".project:contains('My Aim Is True') .project-body[style='display: block']"
    assert_have_selector ".project:contains('My Aim Is True') input[value='aim']"
  end
end
