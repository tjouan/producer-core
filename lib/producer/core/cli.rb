module Producer
  module Core
    class CLI
      ArgumentError = Class.new(::ArgumentError)

      USAGE = "Usage: #{File.basename $0} [-v] [-n] recipe_file".freeze

      EX_USAGE    = 64
      EX_SOFTWARE = 70

      class << self
        def run!(arguments, output: $stderr)
          cli = new(arguments)
          begin
            cli.parse_arguments!
            cli.run
          rescue ArgumentError
            output.puts USAGE
            exit EX_USAGE
          rescue RuntimeError => e
            output.puts "#{e.class.name.split('::').last}: #{e.message}"
            exit EX_SOFTWARE
          end
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
            env.verbose = true
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
