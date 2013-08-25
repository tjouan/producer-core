Feature: `echo' task action

  Scenario: ouputs text
    Given a recipe with:
      """
      task :some_task do
        echo 'hello'
      end
      """
    When I successfully execute the recipe
    And the output must contain exactly "hello\n"
