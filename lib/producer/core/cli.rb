module Producer
  module Core
    class CLI
      ArgumentError = Class.new(::ArgumentError)

      USAGE = "Usage: #{File.basename $0} recipe_file"

      EX_USAGE = 64

      class << self
        def run!(arguments, output: $stderr)
          begin
            cli = new(arguments)
          rescue ArgumentError
            output.puts USAGE
            exit EX_USAGE
          end
          cli.run!
        end
      end

      attr_reader :arguments, :stdout

      def initialize(arguments, stdout: $stdout)
        raise ArgumentError unless arguments.any?
        @arguments  = arguments
        @stdout     = stdout
      end

      def run!
        interpreter.process recipe.tasks
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
    end
  end
end
