Feature: `compose_macro' recipe keyword

  Background:
    Given a recipe named "composed_macro.rb" with:
      """
      macro :hello do |prefix, *args|
        echo 'hello %s %s' % [prefix, args.join(', ')]
      end

      compose_macro :hello_composed, :hello, 'composed'
      """

  Scenario: declares a composed macro as recipe keyword
    Given a recipe with:
      """
      source 'composed_macro'
      hello_composed :foo, :bar
      """
    When I successfully execute the recipe
    Then the output must contain "hello composed foo, bar"

  Scenario: declares a composed macro as task keyword
    Given a recipe with:
      """
      source 'composed_macro'
      task(:some_task) { hello_composed :foo, :bar }
      """
    When I successfully execute the recipe
    Then the output must contain "hello composed foo, bar"
