Then /project "(.*)" is listed/ do |project|
  assert_have_selector ".project:first *:contains('#{project}')"
end

Then /has short link "([\-\w]+)"/ do |link|
  assert_have_selector ".project form[action$=#{link}]"
end

Given /project named "(.*)" exists/ do |name|
  @user.projects.create(:name => name)
end

Given /started tracking "(.*)" (\d+) minutes ago/ do |project, minutes|
  project = Project.first(:name => project)
  @user.track!(project)

  # We need to rewind time, mocking and stubbing yelled at me
  entry = Entry.all.last
  entry.created_at = (Time.now - minutes.to_i * 60)
  entry.save
end

When /start tracking "(.*)"/ do |project|
  within ".project:contains('#{project}')" do |s|
    s.dom = "LOL"
    p s.dom
    click_button 'Track'
  end
end

When /stop tracking/ do 
  click_button 'Stop'
end

Then /"(.*)" is being tracked/ do |project|
  assert_have_selector ".project#tracking *:contains('#{project}')"
end

Then /no projects are being tracked/ do
  assert_have_no_selector "#tracking"
end

Then /doesn't show entry for "(.*)"/ do |project|
  assert_have_no_selector ".project:contains('#{project}') .entry"
end

Given /project "(.*)" has a (\d+) minute entry/ do |project, minutes|
  project = Project.first(:name => project)
  project.entries.create(:duration => minutes.to_i * 60)
end

Then /"(.*)" should have a (\d+) minute entry/ do |project, minutes|
  assert_have_selector ".project:contains('#{project}') .entry:first:contains('#{minutes}')"
end

Then /"(.*)" shows a total of "(.*)"/ do |project, total|
  assert_have_selector ".project:contains('#{project}') .total:contains('#{total}')"
end

When /delete latest entry in "(.*)"/ do |project|
  within ".project:contains('#{project}') .entry:first form" do |f|
    f.click_button
  end
end

Then /"(.*)" should have (\d+) entries/ do |project, entries|
  assert_have_no_selector ".project:contains('#{project}') .entry"
  puts "FIX: css selector to assert number of entries"
end

Then /can't track other projects/ do
  assert_have_no_selector "form[action*=track]"
end
