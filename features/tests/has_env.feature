@sshd
Feature: `has_env' condition keyword

  Scenario: succeeds when remote environment variable is defined
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_env_var_definition do
        condition { has_env :shell }

        echo 'evaluated'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must contain "evaluated"

  Scenario: fails when remote environment variable is not defined
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_env_var_definition do
        condition { has_env :inexistent_var }

        echo 'evaluated'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the output must not contain "evaluated"
