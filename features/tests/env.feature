@sshd
Feature: `env?' condition keyword

  Background:
    Given a recipe with:
      """
      task :env_test_definition_ok do
        condition { env? :shell }

        echo 'definition_ok'
      end

      task :env_test_definition_ko do
        condition { env? :non_existent_var }

        echo 'definition_ko'
      end

      task :env_test_value do
        condition { env? :shell, '/bin/sh' }

        echo 'value_ok'
      end

      task :env_test_value do
        condition { env? :shell, 'non_existent_shell' }

        echo 'value_ko'
      end
      """

  Scenario: succeeds when remote environment variable is defined
    When I successfully execute the recipe on remote target
    Then the output must contain "definition_ok"

  Scenario: fails when remote environment variable is not defined
    When I successfully execute the recipe on remote target
    Then the output must not contain "definition_ko"

  @ci_skip
  Scenario: succeeds when remote environment variable value match
    When I successfully execute the recipe on remote target
    Then the output must contain "value_ok"

  Scenario: fails when remote environment variable value does not match
    When I successfully execute the recipe on remote target
    Then the output must not contain "value_ko"
