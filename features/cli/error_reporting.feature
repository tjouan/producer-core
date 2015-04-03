Feature: CLI error reporting

  Scenario: reports recipe errors
    Given a recipe with an error
    When I execute the recipe
    Then the exit status must be 70
    And the output must match /\ARuntimeError: some error\n/

  Scenario: reports errors with a backtrace
    Given a recipe with an error
    When I execute the recipe
    Then the output must match /^\s+recipe\.rb:\d+:in /

  Scenario: prepends recipe file path in the backtrace
    Given a recipe with an error
    When I execute the recipe
    Then the output must match /^\s+recipe\.rb \(recipe\)\n\s+recipe\.rb:/

  Scenario: excludes net-ssh from backtrace
    Given a recipe using a remote
    When I execute the recipe on unknown remote target
    Then the output must not contain "net-ssh"
