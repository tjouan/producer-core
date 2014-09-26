Feature: key/value registry

  Scenario: `get' keyword in a task fetches a value registered with `set'
    Given a recipe with:
      """
      set :some_key, 'some_value'

      task :registry_testing do
        echo get :some_key
      end
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"

  Scenario: `get' keyword fetches a value from the recipe
    Given a recipe with:
      """
      set :some_key, 'some_value'
      set :other_key, get(:some_key)

      task :registry_testing do
        echo get :other_key
      end
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"

  Scenario: `get' keyword fetches a value from a condition
    Given a recipe with:
      """
      set :some_key, 'some_value'

      task(:ok) { condition { get :some_key }; echo get :some_key }
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"

  Scenario: `get' keyword should trigger an error when given invalid key
    Given a recipe with:
      """
      task :some_task do
        echo get :no_key
        echo 'after_fail'
      end
      """
    When I execute the recipe
    Then the output must not contain "after_fail"
    And the output must match /\A\w+Error:\s+:no_key/
