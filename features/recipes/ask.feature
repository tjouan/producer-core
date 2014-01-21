Feature: `ask' recipe keyword

  Scenario: prompts user with a list of choices on standard output
    Given a recipe with:
      """
      task :ask_letter do
        letter = ask 'Which letter?', [[:a, ?A], [:b, ?B]]

        echo letter.inspect
      end
      """
    When I execute the recipe interactively
    And I type "1"
    Then the output must contain:
      """
      Which letter?
      0: A
      1: B
      Choice:
      :b
      """
    And the exit status must be 0
