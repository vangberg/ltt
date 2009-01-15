Feature: Create projects
  As a user
  I want to be able to create projects
  So I can manage my time

  Scenario: Creating a new project
    Given I am logged in
    When I visit the dashboard
    And fill in "Name" with "Night at Birdland"
    And click button "Create"
    Then project "Night at Birdland" is listed
    And has short link "night-at-birdland"

  Scenario: Creating a new project without a name
