module Producer
  module Core
    class CLI
      attr_reader :arguments

      USAGE = "Usage: #{File.basename $0} host recipe_file"

      def initialize(arguments, stdout = $stdout)
        @stdout     = stdout
        @arguments  = arguments
      end

      def run!
        check_arguments!
        evaluate_recipe_file(@arguments[1])
      end

      def check_arguments!
        print_usage_and_exit(64) unless @arguments.length == 2
      end

      def evaluate_recipe_file(filepath)
        recipe = Recipe.from_file(@arguments[1])
        env = Env.new(recipe)
        recipe.evaluate env
      end


      private

      def print_usage_and_exit(status)
        @stdout.puts USAGE

        exit status
      end
    end
  end
end
