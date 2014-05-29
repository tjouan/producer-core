@sshd
Feature: `file_append' task action

  Background:
    Given a remote file named "some_file" with "some content"

  Scenario: appends given content to requested file
    Given a recipe with:
      """
      target 'some_host.test'

      task :append_content_to_file do
        file_append 'some_file', ' added'
      end
      """
    When I successfully execute the recipe
    Then the remote file "some_file" must contain exactly "some content added"
