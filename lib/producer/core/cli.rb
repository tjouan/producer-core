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
        recipe.evaluate(env)
        worker.process recipe.tasks
      end

      def check_arguments!
        print_usage_and_exit(64) unless @arguments.length == 1
      end

      def env
        @env ||= Env.new
      end

      def recipe
        @recipe ||= Recipe.from_file(@arguments.first)
      end

      def worker
        @worker ||= Worker.new
      end

      private

      def print_usage_and_exit(status)
        @stdout.puts USAGE

        exit status
      end
    end
  end
end
