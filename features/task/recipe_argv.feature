Feature: `recipe_argv' task keyword

  Background:
    Given a recipe with:
      """
      task :echo_arguments do
        echo recipe_argv
      end
      """

  Scenario: returns recipe arguments
    When I successfully execute the recipe with arguments "foo bar"
    Then the output must contain exactly "foo\nbar\n"
