@sshd
Feature: `file_contains' condition keyword

  Background:
    Given a recipe with:
      """
      target 'some_host.test'

      task :file_contains_test do
        condition { file_contains 'some_file', 'some_content' }

        echo 'evaluated'
      end
      """

  Scenario: succeeds when file contains expected content
    Given a remote file named "some_file" with "some_content"
    When I successfully execute the recipe
    Then the output must contain "evaluated"

  Scenario: fails when file does not contain expected content
    Given a remote file named "some_file" with "some_other_content"
    When I successfully execute the recipe
    Then the output must not contain "evaluated"

  Scenario: fails when file does not exist
    When I successfully execute the recipe
    Then the output must not contain "evaluated"
