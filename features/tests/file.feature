@sshd
Feature: `file?' condition keyword

  Background:
    Given a recipe with:
      """
      task :file_test do
        condition { file? 'some_file' }

        echo 'evaluated'
      end
      """

  Scenario: succeeds when file exists
    Given a remote file named "some_file"
    When I successfully execute the recipe on remote target
    Then the output must contain "evaluated"

  Scenario: fails when file does not exist
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"
