@sshd
Feature: `yaml_eq' condition keyword

  Background:
    Given a recipe with:
      """
      task :yaml_eq_test do
        condition { yaml_eq 'some_file', { foo: 'bar' } }

        echo 'evaluated'
      end
      """

  Scenario: succeeds when YAML data is equivalent
    Given a remote file named "some_file" with ":foo: bar"
    When I successfully execute the recipe on remote target
    Then the output must contain "evaluated"

  Scenario: fails when YAML data differs
    Given a remote file named "some_file" with ":foo: baz"
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"

  Scenario: fails when YAML file does not exist
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"
