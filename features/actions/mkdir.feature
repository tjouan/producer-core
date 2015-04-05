@sshd @mocked_home_directory
Feature: `mkdir' task action

  Background:
    Given a recipe with:
      """
      task :mkdir_action do
        mkdir 'some_directory'
        mkdir 'some_directory_0700', mode: 0700
        mkdir 'some_directory_0711', mode: 0711
      end
      """

  Scenario: creates directory given as argument
    When I successfully execute the recipe on remote target
    Then the remote directory "some_directory" must exist

  Scenario: creates directory with given attributes
    When I successfully execute the recipe on remote target
    Then the remote directory "some_directory_0700" must have 0700 mode
    And  the remote directory "some_directory_0711" must have 0711 mode

  Scenario: creates directories recursively
    Given a recipe with:
      """
      task :mkdir_action do
        mkdir 'some/directory'
      end
      """
    When I successfully execute the recipe on remote target
    Then the remote directory "some/directory" must exist
