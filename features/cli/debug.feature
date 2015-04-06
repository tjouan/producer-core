Feature: CLI debug option

  Scenario: reports recipe errors with their cause
    Given a recipe with an error
    When I execute the recipe with option -d
    Then the output must match /\ARuntimeError:.*\n\ncause:\nRuntimeError:/

  Scenario: does not exclude anything from backtrace
    Given a recipe using a remote
    When I execute the recipe on unknown remote target with option -d
    Then the output must contain "producer"
    And the output must contain "net-ssh"
    And the output must contain ruby lib directory

  Scenario: enables debug mode from the environment
    Given a recipe with an error
    And I set the environment variable "PRODUCER_DEBUG"
    When I execute the recipe
    Then the output must contain "producer"
