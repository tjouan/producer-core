module Producer
  module Core
    class Action
      extend Forwardable
      def_delegators :@env, :input, :output, :remote
      def_delegators :remote, :fs

      attr_reader :env, :arguments

      def initialize(env, *args)
        @env        = env
        @arguments  = args
      end
    end
  end
end
