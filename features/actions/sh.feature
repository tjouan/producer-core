@sshd
Feature: `sh' task action

  Scenario: executes command
    Given a recipe with:
      """
      target 'some_host.test'

      task :some_task do
        sh '\true'
      end
      """
    When I execute the recipe
    Then the exit status must be 0

  Scenario: forwards standard ouput
    Given a recipe with:
      """
      target 'some_host.test'

      task :some_task do
        sh '\echo hello from remote'
      end
      """
    When I successfully execute the recipe
    Then the output must contain exactly "hello from remote\n"

  Scenario: aborts on failed command execution
    Given a recipe with:
      """
      target 'some_host.test'

      task :some_task do
        sh '\false'
        sh '\echo after_fail'
      end
      """
    When I execute the recipe
    Then the output must not contain "after_fail"

  Scenario: prints command when execution fail
    Given a recipe with:
      """
      target 'some_host.test'

      task :some_task do
        sh '\false'
      end
      """
    When I execute the recipe
    Then the output must match /\A\w+Error:\s+\\false/
