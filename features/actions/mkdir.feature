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
