@sshd
Feature: `file_write' task action

  Background:
    Given a recipe with:
      """
      target 'some_host.test'

      task :file_write_action do
        file_write 'some_file',       'some_content'
        file_write 'some_file_0600',  'some_content', 0600
        file_write 'some_file_0700',  'some_content', 0700
      end
      """

  Scenario: writes given data to given file path
    When I successfully execute the recipe
    Then the remote file "some_file" must contain "some_content"

  Scenario: creates file with given permissions
    When I successfully execute the recipe
    Then the remote file "some_file_0600" must have 0600 mode
    And  the remote file "some_file_0700" must have 0700 mode