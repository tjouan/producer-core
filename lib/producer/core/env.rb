module Producer
  module Core
    class Env
      attr_reader   :input, :output, :registry, :logger
      attr_accessor :target

      def initialize(input: $stdin, output: $stdout, remote: nil, registry: {})
        @input    = input
        @output   = output
        @registry = registry
        @remote   = remote
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
          logger.level = Logger::ERROR
          logger.formatter = LoggerFormatter.new
          logger
        end
      end

      def log(message)
        logger.info message
      end

      def log_level
        logger.level
      end

      def log_level=(level)
        logger.level = level
      end
    end
  end
end
