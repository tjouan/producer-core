Feature: `source' recipe keyword

  Background:
    Given a recipe with:
      """
      source 'sourced_recipe'
      """

  Scenario: requires a recipe file
    Given a file named "sourced_recipe.rb" with:
      """
      task :some_task do
        echo 'sourced recipe'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "sourced recipe"
