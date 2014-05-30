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
