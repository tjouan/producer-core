Feature: CLI debug option

  Background:
    Given a recipe with:
      """
      task(:trigger_error) { fail 'some error' }
      """

  Scenario: reports recipe errors
    When I execute the recipe with option -d
    Then the output must match /\ARuntimeError:.*\n\ncause:\nRuntimeError:/
