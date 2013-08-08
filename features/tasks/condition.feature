Feature: `condition' task keyword

  Scenario: prevents task actions application when condition is not met
    Given a recipe with:
      """
      task :hello do
        condition { false }

        echo 'evaluated'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must not contain "evaluated"
