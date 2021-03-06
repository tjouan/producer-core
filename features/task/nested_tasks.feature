Feature: nested tasks

  Background:
    Given a recipe with:
      """
      task :outer_task do
        task :inner_task do
          echo 'OK'
        end
      end
      """

    Scenario: applies nested tasks
      When I successfully execute the recipe
      Then the output must match /\AOK/

    Scenario: indents logging from nested tasks
      When I successfully execute the recipe with option -v
      Then the output must match /^  Task:.+/
      And the output must match /^   action:.+/
