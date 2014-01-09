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
          cli.run
        end
      end

      attr_reader :arguments, :stdout
      attr_accessor :recipe

      def initialize(arguments, stdout: $stdout)
        raise ArgumentError unless arguments.any?
        @arguments  = arguments
        @stdout     = stdout
      end

      def run(worker: Worker.new)
        load_recipe
        worker.process recipe.tasks
      end

      def load_recipe
        @recipe = Recipe.evaluate_from_file(@arguments.first, Env.new)
      end
    end
  end
end
