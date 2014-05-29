@sshd
Feature: `file_replace_content' task action

  Background:
    Given a remote file named "some_file" with "some content"
    And a remote file named "other_file" with "some content"
    And a recipe with:
      """
      target 'some_host.test'

      task :file_replace_content_action_string do
        file_replace_content 'some_file', 'content', 'other content'
      end

      task :file_replace_content_action_regexp do
        file_replace_content 'other_file', /\w+\z/, 'other content'
      end
      """

  Scenario: replaces a string by another in the requested file
    When I successfully execute the recipe
    Then the remote file "some_file" must contain exactly "some other content"

  Scenario: replaces a regular expression by a string in the requested file
    When I successfully execute the recipe
    Then the remote file "other_file" must contain exactly "some other content"
