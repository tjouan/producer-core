@sshd
Feature: `file_replace_content' task action

  Background:
    Given a remote file named "some_file" with "some content"

  Scenario: replace a string by another in the requested file
    Given a recipe with:
      """
      target 'some_host.test'

      task :replace_string_in_file do
        file_replace_content 'some_file', 'content', 'other content'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the remote file "some_file" must contain exactly "some other content"

  Scenario: replace a regular expression by a string in the requested file
    Given a recipe with:
      """
      target 'some_host.test'

      task :replace_string_in_file do
        file_replace_content 'some_file', /\w+\z/, 'other content'
      end
      """
    When I execute the recipe
    Then the exit status must be 0
    And the remote file "some_file" must contain exactly "some other content"
