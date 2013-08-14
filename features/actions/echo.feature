Feature: `echo' task action

  Scenario: ouputs text
    Given a recipe with:
      """
      task :some_task do
        echo 'hello'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain exactly "hello\n"
