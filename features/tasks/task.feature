Feature: task evaluation

  Scenario: evaluates ruby code in task blocks
    Given a recipe with:
      """
      task :hello do
        puts 'hello from recipe'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain "hello from recipe"

  Scenario: reports errors for invalid action calls in a task
    Given a recipe with:
      """
      task 'some_task' do
        invalid_action
      end
      """
    When I execute the recipe
    Then the exit status must be 70
    And the output must match:
      """
      \Arecipe.rb:2:.+invalid task action `invalid_action'
      """
