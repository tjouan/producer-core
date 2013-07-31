module Producer
  module Core
    class CLI
      attr_reader :arguments

      USAGE = "Usage: #{File.basename $0} recipe_file"

      def initialize(arguments, stdout = $stdout)
        @stdout     = stdout
        @arguments  = arguments
      end

      def run!
        check_arguments!
        evaluate_recipe_file
      end

      def check_arguments!
        print_usage_and_exit(64) unless @arguments.length == 1
      end

      def evaluate_recipe_file
        recipe = Recipe.from_file(@arguments.first)
        env = Env.new(recipe)
        begin
          recipe.evaluate env
        rescue Recipe::RecipeEvaluationError => e
          @stdout.puts [e.backtrace.shift, e.message].join ': '
          @stdout.puts e.backtrace

          exit 70
        end
      end

      private

      def print_usage_and_exit(status)
        @stdout.puts USAGE

        exit status
      end
    end
  end
end
