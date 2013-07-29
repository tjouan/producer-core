Feature: recipe evaluation

  Scenario: evaluates ruby code in a recipe
    Given a recipe with:
      """
      puts 'hello from recipe'
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain "hello from recipe"

  Scenario: reports errors when evaluating an invalid recipe
    Given a recipe with:
      """
      puts 'OK'

      invalid_keyword
      """
    When I execute the recipe
    Then the exit status must be 70
    And the output must match:
      """
      \AOK
      recipe.rb:3:.+invalid recipe keyword `invalid_keyword'
      """

  Scenario: source keyword, requires a recipe file
    Given a recipe with:
      """
      source 'sourced_recipe'
      """
    And a file named "sourced_recipe.rb" with:
      """
      puts 'sourced recipe'
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain "sourced recipe"
