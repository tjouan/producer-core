Feature: `template' task keyword

  Scenario: renders an ERB template file
    Given a file named "templates/basic.erb" with:
      """
      basic template
      """
    And a recipe with:
      """
      task(:echo_template) { echo template 'basic' }
      """
    When I execute the recipe
    Then the output must contain "basic template"

  Scenario: renders ERB with given attributes as member data
    Given a file named "templates/variables.erb" with:
      """
      <%= @foo %>
      """
    And a recipe with:
      """
      task(:echo_template) { echo template('variables', foo: 'bar') }
      """
    When I execute the recipe
    Then the output must contain "bar"

  Scenario: renders without `templates' search path
    Given a file named "templates/basic.erb" with:
      """
      basic template
      """
    And a recipe with:
      """
      task(:echo_template) { echo template './templates/basic' }
      """
    When I execute the recipe
    Then the output must contain "basic template"

  Scenario: parses a yaml file
    Given a file named "templates/basic.yaml" with:
      """
      foo: bar
      """
    And a recipe with:
      """
      task(:echo_template) { echo template('basic')['foo'] }
      """
    When I execute the recipe
    Then the output must match /^bar$/

  Scenario: read raw files
    Given a file named "templates/basic" with:
      """
      foo
      """
    And a recipe with:
      """
      task(:echo_template) { echo template('basic') }
      """
    When I execute the recipe
    Then the output must contain exactly "foo\n"

  Scenario: reports an error on missing template
    Given a recipe with:
      """
      task(:echo_template) { echo template 'basic' }
      """
    When I execute the recipe
    Then the output must match /\A\w+Error:\s+template `basic' not found\n/
