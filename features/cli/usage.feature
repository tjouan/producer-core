Feature: CLI usage

  @exec
  Scenario: prints the usage when an argument is missing
    When I run `producer`
    Then the exit status must be 64
    And the output must contain exactly:
      """
      Usage: producer [options] [recipes]

      options:
          -v, --verbose                    enable verbose mode
          -d, --debug                      enable debug mode
          -n, --dry-run                    enable dry run mode
          -t, --target HOST                target host
      """