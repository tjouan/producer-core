Feature: CLI dry run option

  Background:
    Given a recipe with:
      """
      task :say_hello do
        echo 'hello'
      end
      """

  Scenario: perfoms a trial run without applying actions
    When I successfully execute the recipe with option -n
    Then the output must not contain "hello"

  Scenario: prints a warning before any output
    When I successfully execute the recipe with option -n
    Then the output must match /\AWarning: running in dry run mode, actions will NOT be applied/
