@sshd
Feature: `executable?' condition keyword

  Background:
    Given a recipe with:
      """
      target 'some_host.test'

      task :executable_test_ok do
        condition { executable? 'true' }

        echo 'test_ok'
      end

      task :executable_test_ok do
        condition { executable? 'some_non_existent_executable' }

        echo 'test_ko'
      end
      """

  Scenario: succeeds when remote executable is available
    When I successfully execute the recipe
    Then the output must contain "test_ok"

  Scenario: fails when remote executable is not available
    When I successfully execute the recipe
    Then the output must not contain "test_ko"
