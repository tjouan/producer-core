Feature: `target' condition keyword

  Scenario: returns the current target
    Given a recipe with:
      """
      target 'some_host.example'

      task :test_target do
        condition { target == 'some_host.example' }

        echo 'OK'
      end
      """
    When I execute the recipe
    Then the output must contain "OK"
