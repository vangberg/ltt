Feature: Tracking API
  In order to bill my clients
  I want to be able to track my time

  Scenario: Start tracking
    Given I am logged in
    And a project named "Kind of Blue" exists
    When I visit the dashboard
    And start tracking "Kind of Blue"
    Then it shows the dashboard
    And "Kind of Blue" is being tracked

  Scenario: Start tracking twice
    Given I am logged in
    And a project named "Out to Lunch" exists
    And a project named "Bitches Brew" exists
    When I visit the dashboard
    And start tracking "Out to Lunch"
    And start tracking "Bitches Brew"
    Then it returns an error

  Scenario: Stop tracking
    Given I am logged in
    And a project named "Unit Structures" exists
    And I started tracking "Unit Structures" 10 minutes ago
    When I visit the dashboard
    And start tracking "Unit Structures"
    And stop tracking
    Then no projects are being tracked
