module Producer
  module Core
    class CLI
      ArgumentError = Class.new(::ArgumentError)

      USAGE = "Usage: #{File.basename $0} [-v] [-n] recipe_file".freeze

      EX_USAGE    = 64
      EX_SOFTWARE = 70

      class << self
        def run!(arguments, stdin: $stdin, stdout: $stdout, stderr: $stderr)
          cli = new(arguments, stdin: stdin, stdout: stdout, stderr: stderr)
          begin
            cli.parse_arguments!
            cli.run
          rescue ArgumentError
            stderr.puts USAGE
            exit EX_USAGE
          rescue RuntimeError => e
            stderr.puts "#{e.class.name.split('::').last}: #{e.message}"
            exit EX_SOFTWARE
          end
        end
      end

      attr_reader :arguments, :stdin, :stdout, :stderr, :env

      def initialize(args, stdin: $stdin, stdout: $stdout, stderr: $stderr)
        @arguments  = args
        @stdin      = stdin
        @stdout     = stdout
        @env        = Env.new(input: stdin, output: stdout)
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

        fail ArgumentError unless arguments.any?
      end

      def run
        worker.process load_recipe.tasks
      end

      def load_recipe
        Recipe.evaluate_from_file(@arguments.first, env)
      end

      def worker
        Worker.new(env)
      end
    end
  end
end
