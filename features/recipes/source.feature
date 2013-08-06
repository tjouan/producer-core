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
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain "sourced recipe"

  Scenario: reports errors from sourced recipes
    Given a file named "sourced_recipe.rb" with:
      """
      puts 'OK'
      invalid_keyword
      """
    When I execute the recipe
    Then the exit status must be 70
    Then the output must match:
      """
      \AOK
      sourced_recipe.rb:2:.+invalid recipe keyword `invalid_keyword'
      recipe.rb:1:.+
      """
