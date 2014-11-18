Feature: `echo' task action

  Scenario: prints text on standard output
    Given a recipe with:
      """
      task :echo_action do
        echo 'hello'
      end
      """
    When I successfully execute the recipe
    Then the output must match /\Ahello\n/
