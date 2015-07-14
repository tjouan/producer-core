Feature: recipe errors

  Scenario: reports when remote target is invalid
    Given a recipe with:
      """
      task(:some_task) { sh 'true' }
      """
    When I execute the recipe
    Then the output must match /\ARemoteInvalidError:\s+\w+/
