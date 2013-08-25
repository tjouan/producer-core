Feature: task evaluation

  Scenario: evaluates ruby code in task blocks
    Given a recipe with:
      """
      task :hello do
        puts 'hello from recipe'
      end
      """
    When I successfully execute the recipe
    And the output must contain exactly "hello from recipe\n"
