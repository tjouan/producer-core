module Producer
  module Core
    class CLI
      ArgumentError = Class.new(::ArgumentError)

      USAGE = "Usage: #{File.basename $0} [options] [recipes]".freeze

      EX_USAGE    = 64
      EX_SOFTWARE = 70

      class << self
        def run!(arguments, stdin: $stdin, stdout: $stdout, stderr: $stderr)
          cli = new(arguments, stdin: stdin, stdout: stdout, stderr: stderr)
          begin
            cli.parse_arguments!
            cli.run
          rescue ArgumentError => e
            stderr.puts e.message
            exit EX_USAGE
          rescue StandardError => e
            ef = ErrorFormatter.new(
              debug:        cli.env.debug?,
              force_cause:  [RecipeEvaluationError]
            )
            stderr.puts ef.format e
            exit EX_SOFTWARE
          end
        end
      end

      attr_reader :arguments, :stdin, :stdout, :stderr, :env

      def initialize(args, stdin: $stdin, stdout: $stdout, stderr: $stderr)
        @arguments  = args
        @stdin      = stdin
        @stdout     = stdout
        @stderr     = stderr
        @env        = build_env
      end

      def parse_arguments!
        option_parser.parse!(@arguments)
        fail ArgumentError, option_parser if @arguments.empty?
      end

      def run(worker: Worker.new(@env))
        evaluate_recipes.each { |recipe| worker.process recipe.tasks }
      ensure
        @env.cleanup
      end

      def evaluate_recipes
        @arguments.map { |e| Recipe::FileEvaluator.evaluate(e, @env) }
      end


      private

      def build_env
        Env.new(input: @stdin, output: @stdout, error_output: @stderr)
      end

      def option_parser
        OptionParser.new do |opts|
          opts.banner = USAGE
          opts.separator ''
          opts.separator 'options:'

          opts.on '-v', '--verbose', 'enable verbose mode' do |e|
            env.verbose = true
          end

          opts.on '-d', '--debug', 'enable debug mode' do |e|
            env.debug = true
          end

          opts.on '-n', '--dry-run', 'enable dry run mode' do |e|
            env.dry_run = true
          end

          opts.on '-t', '--target HOST', 'target host' do |e|
            env.target = e
          end
        end
      end
    end
  end
end
