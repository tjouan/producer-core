Feature: condition

  Scenario: prevents task evaluation when condition is not met
    Given a recipe with:
      """
      task :hello do
        condition { false }

        puts 'evaluated'
        exit 70
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must not contain "evaluated"
