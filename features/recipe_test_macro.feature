Feature: `test_macro' recipe keyword

  Scenario: declares a new test keyword
    Given a recipe with:
      """
      test_macro :even? do |n|
        n % 2 == 0
      end

      [1, 2].each do |n|
        task "test_macro-even-#{n}" do
          condition { even? n }
          echo n
        end
      end
      """
    When I successfully execute the recipe
    Then the output must contain "2"
    And the output must not contain "1"

  @sshd
  Scenario: has access to core tests
    Given a recipe with:
      """
      test_macro(:other_env?) { |k| env? k }

      [:shell, :non_existent_var].each do |k|
        task "test_macro-condition-#{k}" do
          condition { other_env? k }
          echo "#{k}_ok"
        end
      end
      """
    When I successfully execute the recipe on remote target
    Then the output must contain "shell_ok"
    Then the output must not contain "non_existent_var_ok"

  Scenario: has access to other tests declared with `test_macro'
    Given a recipe with:
      """
      test_macro(:one?)       { |e| e == 1 }
      test_macro(:one_alias?) { |e| one? e }

      task :test_macro_macro do
        condition { one_alias? 1 }
        echo 'one_alias_ok'
      end
      """
    When I successfully execute the recipe
    Then the output must contain "one_alias_ok"
