module Producer
  module Core
    class CLI
      USAGE = "Usage: #{File.basename $0} recipe_file"

      attr_reader :arguments

      def initialize(arguments, stdout = $stdout)
        @stdout     = stdout
        @arguments  = arguments
      end

      def run!
        check_arguments!
        interpreter.process recipe.tasks
      end

      def check_arguments!
        print_usage_and_exit(64) unless @arguments.length == 1
      end

      def env
        @env ||= Env.new
      end

      def recipe
        @recipe ||= Recipe.evaluate_from_file(@arguments.first, env)
      end

      def interpreter
        @interpreter ||= Interpreter.new
      end

      private

      def print_usage_and_exit(status)
        @stdout.puts USAGE

        exit status
      end
    end
  end
end
