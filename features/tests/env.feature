@sshd
Feature: `env?' condition keyword

  Scenario: succeeds when remote environment variable is defined
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_env_var_definition do
        condition { env? :shell }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "evaluated"

  Scenario: fails when remote environment variable is not defined
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_env_var_definition do
        condition { env? :non_existent_var }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must not contain "evaluated"

  Scenario: succeeds when remote environment variable value match
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_env_var_value do
        condition { env? :shell, '/bin/sh' }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "evaluated"

  Scenario: fails when remote environment variable value does not match
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_env_var_value do
        condition { env? :shell, 'non_existent_shell' }

        echo 'evaluated'
      end
      """
    When I successfully execute the recipe
    Then the output must not contain "evaluated"
