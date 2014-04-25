@sshd
Feature: `mkdir' task action

  Scenario: creates directory given as argument
    Given a recipe with:
      """
      target 'some_host.test'

      task :create_some_dir do
        mkdir 'some_directory'
      end
      """
    When I successfully execute the recipe
    Then the remote directory "some_directory" must exists

  Scenario: creates directory with given permissions
    Given a recipe with:
      """
      target 'some_host.test'

      task :create_some_dir do
        mkdir '0700_directory', 0700
        mkdir '0500_directory', 0500
      end
      """
    When I successfully execute the recipe
    Then the remote directory "0700_directory" must have 0700 mode
    And  the remote directory "0500_directory" must have 0500 mode
