Feature: Authentication
  In order to use the system
  As a user
  I want to be able to login

  Scenario: Valid credentials
    Given a user with login "Blakey" and password "Cannonball"
    And I login with login "Blakey" and password "Cannonball"
    Then it shows the dashboard
    And current user is "Blakey"

  Scenario: Invalid password
    Given a user with login "Ra" and password "Space"
    When I login with login "Ra" and password "Earth"
    Then it doesn't show dashboard

  Scenario: Non-existing user
    When I login with login "Parker" and password "Birdland"
    Then it doesn't show dashboard
