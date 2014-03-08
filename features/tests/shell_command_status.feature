@sshd
Feature: `` condition keyword

  Scenario: succeeds when remote command execution is a success
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_remote_command do
        condition { `true` }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "evaluated"

  Scenario: succeeds when remote executable is available
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_remote_command do
        condition { `false` }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must not contain "evaluated"
