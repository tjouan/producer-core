Feature: recipe evaluation

  Scenario: evaluates ruby code in a recipe
    Given a recipe with:
      """
      puts 'hello from recipe'
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain "hello from recipe"
