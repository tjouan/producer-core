Feature: `source' recipe keyword

  Background:
    Given a recipe with:
      """
      source 'sourced_recipe'
      """

  Scenario: requires a recipe file
    Given a file named "sourced_recipe.rb" with:
      """
      puts 'sourced recipe'
      """
    When I successfully execute the recipe
    And the output must contain "sourced recipe"
