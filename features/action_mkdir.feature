@sshd
Feature: `mkdir' task action

  Background:
    Given a recipe with:
      """
      target 'some_host.test'

      task :mkdir_action do
        mkdir 'some_directory'
        mkdir 'some_directory_0700', 0700
        mkdir 'some_directory_0500', 0500
      end
      """

  Scenario: creates directory given as argument
    When I successfully execute the recipe
    Then the remote directory "some_directory" must exists

  Scenario: creates directory with given permissions
    When I successfully execute the recipe
    Then the remote directory "some_directory_0700" must have 0700 mode
    And  the remote directory "some_directory_0500" must have 0500 mode
