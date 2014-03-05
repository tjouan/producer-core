@sshd
Feature: `file_write' task action

  Scenario: writes given data to given file path
    Given a recipe with:
      """
      target 'some_host.test'

      task :write_some_data do
        file_write 'some_file', 'some_content'
      end
      """
    When I successfully execute the recipe
    And the remote file "some_file" must contain "some_content"
