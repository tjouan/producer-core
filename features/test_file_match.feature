@sshd
Feature: `file_match' condition keyword

  Background:
    Given a recipe with:
      """
      task :file_match_test do
        condition { file_match 'some_file', /\Asome_content\z/ }

        echo 'evaluated'
      end
      """

  Scenario: succeeds when file match pattern
    Given a remote file named "some_file" with "some_content"
    When I successfully execute the recipe on remote target
    Then the output must contain "evaluated"

  Scenario: fails when file does not match pattern
    Given a remote file named "some_file" with "some_other_content"
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"

  Scenario: fails when file does not exist
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"
