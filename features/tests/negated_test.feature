@sshd
Feature: negated test prefix (no_)

  Scenario: prefixed test fails when non-prefixed test is successful
    Given a recipe with:
      """
      target 'some_host.test'

      task :successful_test do
        condition { env? :shell }

        echo 'successful_test'
      end

      task :negated_test do
        condition { no_env? :shell }

        echo 'negated_test'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "successful_test"
    And the output must not contain "negated_test"

  Scenario: prefixed test fails when non-prefixed test is failing
    Given a recipe with:
      """
      target 'some_host.test'

      task :failing_test do
        condition { env? :inexistent_var }

        echo 'failing_test'
      end

      task :negated_test do
        condition { no_env? :inexistent_var }

        echo 'negated_test'
      end
      """
    When I successfully execute the recipe
    Then the output must not contain "failing_test"
    And the output must contain "negated_test"
