Given /am logged in/ do
  @user = User.first(:login => 'Coltrane') || User.create(:login => 'Coltrane', :password => 'Olatunji')

  # blank slate
  @user.tracking = nil
  @user.save

  basic_auth('Coltrane', 'Olatunji')
end

Given /visit the dashboard/ do
  visit '/dashboard'
end

Given /fill in "(.*)" with "(.*)"/ do |field, value|
  fill_in field, :with => value
end

Given /click button "(.*)"/ do |button|
  click_button button
end

Then /returns an error/ do
  assert_equal 403, response_code
end
