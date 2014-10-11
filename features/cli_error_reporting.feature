Feature: CLI error reporting

  Background:
    Given a recipe with:
      """
      task(:trigger_error) { fail 'some error' }
      """

  Scenario: reports recipe errors
    When I execute the recipe
    Then the exit status must be 70
    And the output must match /\ARuntimeError: some error\n/

  Scenario: reports errors with a backtrace
    When I execute the recipe
    Then the output must match /^\s+recipe\.rb:\d+:in /

  Scenario: prepends recipe file path in the backtrace
    When I execute the recipe
    Then the output must match /^\s+recipe\.rb \(recipe\)\n\s+recipe\.rb:/
