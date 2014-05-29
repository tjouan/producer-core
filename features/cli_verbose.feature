Feature: CLI verbose option

  Background:
    Given a recipe with:
      """
      task :task_ok do
        condition { true }

        echo 'some mesasge'
      end

      task :task_ko do
        condition { false }
      end
      """

  Scenario: prints tasks name
    When I successfully execute the recipe with option -v
    Then the output must match /Task:.+task_ok/

  Scenario: prints whether condition is met
    When I successfully execute the recipe with option -v
    Then the output must match /task_ok.+ condition: met.*task_ko.* condition: NOT met/

  Scenario: prints actions info
    When I successfully execute the recipe with option -v
    Then the output must match /task_ok.+ action: echo/

  Scenario: formats message with our simple logger
    When I successfully execute the recipe with option -v
    Then the output must match /\ATask:.+task_ok.*\n.*condition/
