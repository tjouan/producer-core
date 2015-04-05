@sshd @mocked_home_directory
Feature: `yaml_write' task action

  Background:
    Given a recipe with:
      """
      task :yaml_write_action do
        yaml_write 'some_file', data: { foo: 'bar' }
      end
     """

  Scenario: writes given data as YAML
    When I successfully execute the recipe on remote target
    Then the remote file "some_file" must match /^:foo: bar$/
