Feature: key/value registry

  Scenario: `set' keyword registers a value in the registry
    Given a recipe with:
      """
      set :some_key, 'some_value'

      puts env.registry[:some_key]
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"

  Scenario: `get' keyword fetches a value from the registry
    Given a recipe with:
      """
      set :some_key, 'some_value'

      puts get :some_key
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"
