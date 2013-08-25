Feature: recipe evaluation

  Scenario: evaluates ruby code in a recipe
    Given a recipe with:
      """
      puts 'hello from recipe'
      """
    When I successfully execute the recipe
    And the output must contain exactly "hello from recipe\n"
