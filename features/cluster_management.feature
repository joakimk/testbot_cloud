Feature: Cluster management
  In order to run my tests in the cloud
  As a build monkey 
  I want to be able to start, stop and check status on the cloud instances

  Scenario: Staring with 2 instances
    Given I generate a project
    And I start the testbot cluster
    Then I should see "Starting 2 runners..."
    And I should see " up, installing testbot..."
    And I should see " ready."
    And I should not see any errors

