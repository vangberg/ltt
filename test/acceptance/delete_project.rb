require File.join(File.dirname(__FILE__), '..', 'helpers.rb')

class DeleteProjectTest < Test::Unit::AcceptanceTestCase
  story <<-EOS
    As a user
    I want to delete projects
    So I don't old clients hangin' around
  EOS

  scenario "a user deletes a project" do
    login!
    @user.projects.create(:name => "Blood Visions")

    visit '/'
    within ".project:contains('Blood Visions')" do
      click_button 'Delete'
    end

    assert_have_no_selector ".project:contains('Blood Visions')"
  end
end
