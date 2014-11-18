@sshd
Feature: `dir?' condition keyword

  Background:
    Given a recipe with:
      """
      task :dir_test do
        condition { dir? 'some_directory' }

        echo 'evaluated'
      end
      """

  Scenario: succeeds when directory exists
    Given a remote directory named "some_directory"
    When I successfully execute the recipe on remote target
    Then the output must contain "evaluated"

  Scenario: fails when directory does not exist
    When I successfully execute the recipe on remote target
    Then the output must not contain "evaluated"
