Feature: CLI verbose option

  Scenario: prints tasks name
    Given a recipe with:
      """
      task :say_hello do
      end
      """
    When I successfully execute the recipe with option -v
    Then the output must match /Task:.+say_hello/

  Scenario: prints whether condition is met
    Given a recipe with:
      """
      task :task_ok do
        condition { true }
      end
      task :task_ko do
        condition { false }
      end
      """
    When I successfully execute the recipe with option -v
    Then the output must match /task_ok.+ condition: met.*task_ko.* condition: NOT met/

  Scenario: prints actions info
    Given a recipe with:
      """
      task :say_hello do
        echo 'hello message'
      end
      """
    When I successfully execute the recipe with option -v
    Then the output must match /say_hello.+ action: echo/

  Scenario: formats message with our simple logger
    Given a recipe with:
      """
      task :say_hello do
      end
      """
    When I successfully execute the recipe with option -v
    Then the output must match /\ATask:.+say_hello.*\n.*condition/
