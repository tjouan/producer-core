module Producer
  module Core
    class CLI
      ArgumentError = Class.new(::ArgumentError)

      OPTIONS_USAGE = '[-v] [-n] [-t host.example]'.freeze
      USAGE = "Usage: #{File.basename $0} #{OPTIONS_USAGE} recipe_file".freeze

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

      attr_reader :arguments, :env

      def initialize(args, stdin: $stdin, stdout: $stdout, stderr: $stderr)
        @arguments  = args
        @stdin      = stdin
        @stdout     = stdout
        @env        = Env.new(input: stdin, output: stdout, error_output: stderr)
      end

      def parse_arguments!
        @arguments = arguments.each_with_index.inject([]) do |m, (e, i)|
          case e
          when '-v'
            env.verbose = true
          when '-n'
            env.dry_run = true
          when '-t'
            env.target = arguments.delete_at i + 1
          else
            m << e
          end
          m
        end

        fail ArgumentError unless @arguments.any?
      end

      def run(worker: Worker.new(@env))
        worker.process recipe.tasks
        @env.cleanup
      end

      def recipe
        @recipe ||= Recipe.evaluate_from_file(@arguments.first, env)
      end
    end
  end
end
