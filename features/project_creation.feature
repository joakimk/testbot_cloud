Feature: Project creation
  In order to run my tests in the cloud
  As a build monkey 
  I want to create a project that represents my testbot cluster

  Background:
    Given there is no project

  Scenario: Creating a project
    When I generate a project
    Then there should be a project folder
    And the project folder should contain config files for EC2

