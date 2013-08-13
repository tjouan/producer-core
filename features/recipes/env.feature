Feature: `env' recipe keyword

  Scenario: exposes the internal env object
    Given a recipe with:
      """
      env
      """
    When I execute the recipe
    Then the exit status must be 0
