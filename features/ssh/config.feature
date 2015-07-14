Feature: SSH settings

  Background:
    Given a recipe with:
      """
      target 'some_host.example'

      task :some_task do
        echo env.remote.user_name
      end
      """

  Scenario: uses current user login name as SSH user name by default
    When I successfully execute the recipe
    Then the output must contain my current login name

  @mocked-home-directory
  Scenario: uses configured SSH user name for a given host
    Given an SSH config with:
      """
      Host some_host.example
        User some_user
      """
    When I successfully execute the recipe
    Then the output must contain "some_user"
