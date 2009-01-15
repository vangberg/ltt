Feature: Delete projects
  As a user
  I want to be able to delete projects
  So terminated projects won't clutter the interface

  Scenario: Deleting a project
    Given I am logged in
    And a project named "Blue Train" exists
    When I visit the project "Blue Train"
    And click link "Delete"
    Then it shows the dashboard
    And project "Blue Train" is not listed
