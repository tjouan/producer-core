Feature: tasks

  Scenario: evaluates ruby code grouped in task blocks
    Given a recipe with:
      """
      task :hello do
        puts 'hello from recipe'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain "hello from recipe"
