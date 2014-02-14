module Producer
  module Core
    class Env
      attr_reader   :input, :output, :registry
      attr_accessor :target

      def initialize(input: $stdin, output: $stdout, registry: {})
        @input    = input
        @output   = output
        @registry = registry
        @target   = nil
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
    end
  end
end
