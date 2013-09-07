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
        sh '\echo from remote'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "from remote"

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
