Feature: negated test prefix (no_)

  Scenario: prefixed test fails when non-prefixed test is successful
    Given a recipe with:
      """
      test_macro :even? do |n|
        n % 2 == 0
      end

      task :successful_test do
        condition { even? 4 }

        echo 'successful_test'
      end

      task :negated_test do
        condition { no_even? 4 }

        echo 'negated_test'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "successful_test"
    And the output must not contain "negated_test"

  Scenario: prefixed test succeed when non-prefixed test is failing
    Given a recipe with:
      """
      test_macro :even? do |n|
        n % 2 == 0
      end

      task :failing_test do
        condition { even? 5 }

        echo 'failing_test'
      end

      task :negated_test do
        condition { no_even? 5 }

        echo 'negated_test'
      end
      """
    When I successfully execute the recipe
    Then the output must not contain "failing_test"
    And the output must contain "negated_test"
