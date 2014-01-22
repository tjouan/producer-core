module Producer
  module Core
    class Test
      extend Forwardable
      def_delegators :@env, :remote
      def_delegators :remote, :fs

      attr_reader :env, :arguments

      def initialize(env, *arguments, negated: false)
        @env        = env
        @arguments  = arguments
        @negated    = negated
      end

      def negated?
        @negated
      end

      def pass?
        verify ^ negated?
      end
    end
  end
end
