@sshd
Feature: `has_file' condition keyword

  Background:
    Given a recipe with:
      """
      target 'some_host.test'

      task :testing_file_existence do
        condition { has_file 'some_file' }

        echo 'evaluated'
      end
      """

  Scenario: succeeds when file exists
    Given a remote file named "some_file"
    When I successfully execute the recipe
    Then the output must contain "evaluated"

  Scenario: fails when file does not exist
    When I successfully execute the recipe
    Then the output must not contain "evaluated"
