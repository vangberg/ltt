Feature: Entries
  I want to be able to delete entries
  So I don't have to bill clients
  If I fuck up with tracking

  Scenario: Delete entry
    Given I am logged in
    And a project named "Native Songs" exists
    And project "Native Songs" has a 10 minute entry
    When I visit the dashboard
    And delete latest entry in "Native Songs"
    Then it shows the dashboard
    And "Native Songs" should have 0 entries
