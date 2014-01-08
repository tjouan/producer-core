module Producer
  module Core
    class Action
      require 'forwardable'

      extend Forwardable
      def_delegator :@env, :output

      attr_accessor :env, :arguments

      def initialize(env, *args)
        @env        = env
        @arguments  = args
      end
    end
  end
end
