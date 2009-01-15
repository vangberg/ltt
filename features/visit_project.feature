Feature: Visit project
  As a user I want to be able to show projects
  So I can get an overview on time usage
  And edit information

  Scenario: Visit project
    Given I am logged in
    And a project named "Out to Lunch" exists
    When I visit the project "Out to Lunch"
