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

      attr_reader :arguments, :stdout, :env, :recipe

      def initialize(args, stdout: $stdout)
        @arguments  = args
        @stdout     = stdout
        @env        = Env.new(output: stdout)
        raise ArgumentError unless arguments.any?
      end

      def run(worker: build_worker)
        load_recipe
        worker.process recipe.tasks
      end

      def load_recipe
        @recipe = Recipe.evaluate_from_file(@arguments.first, env)
      end

      def build_worker
        Worker.new(env)
      end
    end
  end
end
