@sshd
Feature: `file_eq' condition keyword

  Background:
    Given a recipe with:
      """
      task :file_eq_test do
        condition { file_eq 'some_file', 'some content' }

        echo 'evaluated'
      end
      """

  Scenario: succeeds when file content is expected content
    Given a remote file named "some_file" with "some content"
    When I successfully execute the recipe on remote target
    Then the output must contain "evaluated"

  Scenario: fails when file content is not expected content
    Given a remote file named "some_file" with "some content padded"
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"

  Scenario: fails when file does not exist
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"
