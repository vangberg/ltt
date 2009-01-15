Feature: Visit project
  As a user I want to be able to show projects
  So I can get an overview on time usage
  And edit information

  Scenario: Visit project
    Given I am logged in
    And a project named "Out to Lunch" exists
    And project "Out to Lunch" has a 10 minute entry
    And project "Out to Lunch" has a 25 minute entry
    When I visit the dashboard
    Then "Out to Lunch" shows a total of "35m"
