Feature: `target' recipe keyword

  Scenario: registers the target host on which tasks should be applied
    Given a recipe with:
      """
      target 'some_host.example'

      task :some_task do
        echo env.target
      end
      """
    When I successfully execute the recipe
    Then the output must contain "some_host.example"

  Scenario: returns current target when no arguments are provided
    Given a recipe with:
      """
      target 'some_host.example'

      env.output.puts target
      """
    When I successfully execute the recipe
    Then the output must contain "some_host.example"
