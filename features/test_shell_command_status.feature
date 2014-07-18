@sshd
Feature: `sh' and `` condition keyword

  Background:
    Given a recipe with:
      """
      task :sh_test_ok do
        condition { sh 'true' }

        echo 'test_ok'
      end

      task :sh_test_ko do
        condition { sh 'false' }

        echo 'test_ko'
      end

      task :sh_test_backtick_ok do
        condition { `true` }

        echo 'test_backtick_ok'
      end

      task :sh_test_backtick_ko do
        condition { `false` }

        echo 'test_backtick_ko'
      end
      """

  Scenario: succeeds when remote command execution is a success
    When I successfully execute the recipe on remote target
    Then the output must contain "test_ok"

  Scenario: fails when remote executable is not available
    When I successfully execute the recipe on remote target
    Then the output must not contain "test_ko"

  Scenario: `` alias, succeeds when remote executable is available
    When I successfully execute the recipe on remote target
    Then the output must contain "test_backtick_ok"

  Scenario: `` alias, fails when remote executable is not available
    When I successfully execute the recipe on remote target
    Then the output must not contain "test_backtick_ko"
