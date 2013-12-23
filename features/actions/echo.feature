Feature: `echo' task action

  Scenario: prints text on standard output
    Given a recipe with:
      """
      task :say_hello do
        echo 'hello'
      end
      """
    When I successfully execute the recipe
    Then the output must match /\Ahello\n/
