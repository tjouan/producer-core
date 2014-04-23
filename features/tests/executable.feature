@sshd
Feature: `executable?' condition keyword

  Scenario: succeeds when remote executable is available
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_executable_availability do
        condition { executable? 'true' }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "evaluated"

  Scenario: succeeds when remote executable is available
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_executable_availability do
        condition { executable? 'some_non_existent_executable' }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must not contain "evaluated"
