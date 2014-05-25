module Producer
  module Core
    class CLI
      ArgumentError = Class.new(::ArgumentError)

      USAGE = "Usage: #{File.basename $0} [-v] [-n] recipe_file".freeze

      EX_USAGE = 64

      class << self
        def run!(arguments, output: $stderr)
          begin
            cli = new(arguments)
            cli.parse_arguments!
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
      end

      def parse_arguments!
        @arguments = arguments.inject([]) do |m, e|
          case e
          when '-v'
            env.log_level = Logger::INFO
          when '-n'
            env.dry_run = true
          else
            m << e
          end
          m
        end

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
