module Producer
  module Core
    class Action
      extend Forwardable
      def_delegators :@env, :input, :output, :error_output, :remote
      def_delegators :remote, :fs

      attr_reader :env, :arguments

      def initialize(env, *args)
        @env        = env
        @arguments  = args
      end

      def name
        self.class.name.split('::').last.downcase
      end

      def to_s
        name
      end
    end
  end
end
