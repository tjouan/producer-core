Feature: CLI dry run option

  Scenario: perfoms a trial run without applying actions
    Given a recipe with:
      """
      task :say_hello do
        echo 'hello'
      end
      """
    When I successfully execute the recipe with option -n
    Then the output must not contain "hello"
