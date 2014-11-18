Feature: `target' task keyword

  Scenario: returns the current target
    Given a recipe with:
      """
      target 'some_host.example'

      task(:echo_target) { echo target }
      """
    When I execute the recipe
    Then the output must contain "some_host.example"
