module Producer
  module Core
    class CLI
      ArgumentError = Class.new(::ArgumentError)

      USAGE = "Usage: #{File.basename $0} [options] [recipes]".freeze

      EX_USAGE    = 64
      EX_SOFTWARE = 70

      ARGUMENTS_SEPARATOR = '--'.freeze

      ENV_VERBOSE_KEY = 'PRODUCER_VERBOSE'.freeze
      ENV_DEBUG_KEY   = 'PRODUCER_DEBUG'.freeze
      ENV_DRYRUN_KEY  = 'PRODUCER_DRYRUN'.freeze

      class << self
        def run! arguments, stdin: $stdin, stdout: $stdout, stderr: $stderr
          cli = new(
            arguments, ENV, stdin: stdin, stdout: stdout, stderr: stderr
          )
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

      def initialize args, environment, stdin: $stdin, stdout: $stdout,
          stderr: $stderr
        @arguments  = args
        @stdin      = stdin
        @stdout     = stdout
        @stderr     = stderr
        @env        = build_env

        configure_environment! environment
      end

      def parse_arguments!
        if @arguments.include? ARGUMENTS_SEPARATOR
          @arguments, @env.recipe_argv = split_arguments_lists @arguments
        end
        option_parser.parse!(@arguments)
        fail ArgumentError, option_parser if @arguments.empty?
      end

      def run worker: Worker.new(@env)
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

      def configure_environment! environment
        @env.verbose  = true if environment.key? ENV_VERBOSE_KEY
        @env.debug    = true if environment.key? ENV_DEBUG_KEY
        @env.dry_run  = true if environment.key? ENV_DRYRUN_KEY
      end

      def split_arguments_lists arguments
        arguments
          .chunk  { |e| e == ARGUMENTS_SEPARATOR }
          .reject { |a, _| a }
          .map    &:last
      end

      def option_parser
        OptionParser.new do |opts|
          opts.banner = USAGE
          opts.separator ''
          opts.separator 'options:'

          option_parser_add_boolean_options opts
          opts.on '-t', '--target HOST', 'target host' do |e|
            env.target = e
          end
        end
      end

      def option_parser_add_boolean_options opts
        { v: 'verbose', d: 'debug', n: 'dry run' }.each do |k, v|
          opts.on "-#{k}", "--#{v.tr ' ', '-'}", "enable #{v} mode" do
            env.send "#{v.tr ' ', '_'}=", true
          end
        end
      end
    end
  end
end
