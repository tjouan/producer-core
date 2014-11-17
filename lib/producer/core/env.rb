module Producer
  module Core
    class Env
      extend Forwardable
      def_delegators :@registry, :[]=

      attr_reader   :input, :output, :error_output, :registry, :logger
      attr_accessor :target, :verbose, :debug, :dry_run

      def initialize(input: $stdin, output: $stdout, error_output: $stderr, remote: nil, registry: {})
        @verbose = @debug = @dry_run = false
        @input        = input
        @output       = output
        @error_output = error_output
        @remote       = remote
        @registry     = registry
      end

      def remote
        @remote ||= Remote.new(target)
      end

      def [](key)
        @registry.fetch key
      rescue KeyError
        fail RegistryKeyError, key.inspect
      end
      alias get []

      def logger
        @logger ||= begin
          logger = Logger.new(output)
          logger.level = verbose? ? Logger::INFO : Logger::WARN
          logger.formatter = LoggerFormatter.new
          logger
        end
      end

      def log(message, severity = :info)
        logger.send severity, message
      end

      def verbose?
        @verbose
      end

      def debug?
        @debug
      end

      def dry_run?
        @dry_run
      end

      def cleanup
        remote.cleanup
      end
    end
  end
end
