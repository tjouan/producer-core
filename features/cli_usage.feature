Feature: CLI usage

  @exec
  Scenario: prints the usage when an argument is missing
    When I run `producer`
    Then the exit status must be 64
    And the output must contain exactly:
      """
      Usage: producer [-v] [-n] recipe_file
      """
