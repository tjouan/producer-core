Feature: `condition' task keyword

  Scenario: prevents task actions application when condition is not met
    Given a recipe with:
      """
      task :some_task do
        condition { false }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must not contain "evaluated"
