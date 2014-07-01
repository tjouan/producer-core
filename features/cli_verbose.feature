Feature: CLI verbose option

  Background:
    Given a recipe with:
      """
      task :task_ok do
        condition { true }

        echo 'some message'
      end

      task :task_ko do
        condition { false }
      end
      """

  Scenario: prints tasks name
    When I successfully execute the recipe with option -v
    Then the output must match /^Task:.+`task_ok'/
    And  the output must match /^Task:.+`task_ko'/

  Scenario: appends `applying' or `skipped' after tasks name
    When I successfully execute the recipe with option -v
    Then the output must match /task_ok.+applying...$/
    And  the output must match /task_ko.+skipped$/

  Scenario: prints actions info
    When I successfully execute the recipe with option -v
    Then the output must match /^ action: echo/

  Scenario: formats message with our simple logger
    When I successfully execute the recipe with option -v
    Then the output must match /\ATask:/
