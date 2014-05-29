Feature: `macro' recipe keyword

  Scenario: declares a new keyword accepting task code
    Given a recipe with:
      """
      macro :hello do
        echo 'hello macro'
      end

      hello
      """
    When I successfully execute the recipe
    Then the output must contain "hello macro"

  Scenario: supports arguments
    Given a recipe with:
      """
      macro :my_echo do |kind, message|
        echo "#{kind}: #{message}"
      end

      my_echo 'my', 'hello'
      """
    When I successfully execute the recipe
    Then the output must contain "my: hello"

  Scenario: supports arguments in conditions
    Given a recipe with:
      """
      macro :my_echo do |message|
        condition { message =~ /foo/ }

        echo message
      end

      %w[foo bar].each { |e| my_echo e }
      """
    When I successfully execute the recipe
    Then the output must contain "foo"
    And the output must not contain "bar"
