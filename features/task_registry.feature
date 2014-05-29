Feature: access to registry from task DSL

  Scenario: `get' keyword fetches a value from the registry
    Given a recipe with:
      """
      set :some_key, 'some_value'

      task :output_some_key do
        echo get :some_key
      end
      """
    When I successfully execute the recipe
    Then the output must contain "some_value"
