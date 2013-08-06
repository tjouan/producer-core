Feature: `env' recipe keyword

  Scenario: exposes the internal env object
    Given a recipe with:
      """
      puts env.current_recipe.filepath
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain exactly "recipe.rb\n"
