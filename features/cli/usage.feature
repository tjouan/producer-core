Feature: CLI usage

  @exec
  Scenario: prints the usage when an argument is missing
    When I run `producer`
    Then the exit status must be 64
    And the output must contain exactly the usage

  @exec
  Scenario: prints the usage when unknown option switch is given
    When I run `producer --unknown-option`
    Then the exit status must be 64
    And the output must contain exactly the usage
