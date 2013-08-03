Feature: target recipe keyword

  Scenario: registers the target host on which tasks should be evaluated
    Given a recipe with:
      """
      target 'some_host.example'

      puts env.target
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain exactly "some_host.example\n"
