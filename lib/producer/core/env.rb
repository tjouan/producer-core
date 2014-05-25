module Producer
  module Core
    class Env
      attr_reader   :input, :output, :registry, :logger
      attr_accessor :target, :verbose, :dry_run

      def initialize(input: $stdin, output: $stdout, remote: nil, registry: {})
        @verbose  = @dry_run = false
        @input    = input
        @output   = output
        @remote   = remote
        @registry = registry
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
          logger.level = verbose? ? Logger::INFO : Logger::ERROR
          logger.formatter = LoggerFormatter.new
          logger
        end
      end

      def log(message)
        logger.info message
      end

      def verbose?
        @verbose
      end

      def dry_run?
        @dry_run
      end
    end
  end
end
