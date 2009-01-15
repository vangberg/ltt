Then /project "(.*)" is listed/ do |project|
  assert_have_selector ".project:first *:contains('#{project}')"
end

Then /has short link "([\-\w]+)"/ do |link|
  assert_have_selector ".project a[href$=#{link}]"
end

Given /project named "(.*)" exists/ do |name|
  @user.projects.create(:name => name)
end

Given /started tracking "(.*)" (\d+) minutes ago/ do |project, minutes|
  past = Time.now - 10 * 60
  #mock(Time).now {past}
end

When /start tracking "(.*)"/ do |project|
  within ".project:contains('#{project}')" do
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

Then /new entry with (\d+) minutes duration is added/ do |minutes|
  assert_have_selector "#entries .entry:first:contains('10')"
end
