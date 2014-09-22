Feature: `compose_macro' recipe keyword

  Scenario: allows macro composition
    Given a recipe with:
      """
      macro :hello do |prefix, *args|
        echo 'hello %s %s' % [prefix, args.join(', ')]
      end

      compose_macro :hello_composed, :hello, 'composed'

      hello_composed :foo, :bar
      """
    When I successfully execute the recipe
    Then the output must contain "hello composed foo, bar"
