Feature: `template' task keyword

  Background:
    Given a file named "basic.erb" with:
      """
      basic template
      """
    Given a file named "variables.erb" with:
      """
      <%= @foo %>
      """

  Scenario: renders an ERB template file
    Given a recipe with:
      """
      task(:echo_template) { echo template 'basic' }
      """
    When I execute the recipe
    Then the output must contain "basic template"

  Scenario: renders ERB with given attributes as member data
    Given a recipe with:
      """
      task(:echo_template) { echo template('variables', foo: 'bar') }
      """
    When I execute the recipe
    Then the output must contain "bar"
