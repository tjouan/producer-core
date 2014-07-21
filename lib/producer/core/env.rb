module Producer
  module Core
    class Env
      attr_reader   :input, :output, :error_output, :registry, :logger
      attr_accessor :target, :verbose, :dry_run

      def initialize(input: $stdin, output: $stdout, error_output: $stderr, remote: nil, registry: {})
        @verbose      = @dry_run = false
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
        @registry[key]
      end

      def []=(key, value)
        @registry[key] = value
      end

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

      def dry_run?
        @dry_run
      end

      def cleanup
        remote.cleanup
      end
    end
  end
end
