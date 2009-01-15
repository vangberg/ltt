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
    And doesn't show entry for "Kind of Blue"

  Scenario: When tracking, don't show Track buttons
    Given I am logged in
    And a project named "Safe as Milk" exists
    And a project named "Trout Mask Replica" exists
    When I visit the dashboard
    And start tracking "Safe as Milk"
    Then I can't track other projects

  Scenario: Stop tracking
    Given I am logged in
    And a project named "Unit Structures" exists
    When I visit the dashboard
    And start tracking "Unit Structures"
    And stop tracking
    Then no projects are being tracked

  Scenario: Stop tracking
    Given I am logged in
    And a project named "Loveless" exists
    And I started tracking "Loveless" 10 minutes ago
    When I visit the dashboard
    And stop tracking
    Then no projects are being tracked
    And a 10 minute entry is added to "Loveless"
