Given /user with login "(\w+)" and password "(\w+)"/ do |login, password|
  User.create(:login => login, :password => password)
end

Given /login with login "(\w+)" and password "(\w+)"/ do |login, password|
  basic_auth(login, password)
  visit '/'
end

Then /shows the dashboard/ do
  assert_have_selector "h1:contains('time tracker')"
end

Then /current user is "(.*)"/ do |user|
  assert_have_selector "#user:contains('#{user}')"
end

Then /doesn't show dashboard/ do
  assert_have_no_selector "h1:contains('time tracker')"
end
