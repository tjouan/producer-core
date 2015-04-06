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

  Scenario: `get' keyword accepts a default value
    Given a recipe with:
      """
      task :registry_testing do
        echo get(:some_key, 'some_value')
      end
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"

  Scenario: `set' keyword sets a value from a task
    Given a recipe with:
      """
      task :registry_testing do
        set :some_key, 'some_value'
        echo get :some_key
      end
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"

  Scenario: `set?' keyword tests wether given key is defined
    Given a recipe with:
      """
      set :some_key, 'some_value'
      task :registry_testing do
        echo 'some_value_set' if set? :some_key
        echo 'other_value' if set? :other_key
      end
      """
    When I execute the recipe
    Then the output must contain "some_value_set"
    And the output must not contain "other_value"
