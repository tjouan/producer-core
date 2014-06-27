Feature: CLI target option

  Background:
    Given a recipe with:
      """
      target 'some_host.example'

      task :some_task do
        echo env.target
      end
      """

  Scenario: prints tasks name
    When I successfully execute the recipe with option -t other_host.example
    Then the output must contain exactly "other_host.example\n"
