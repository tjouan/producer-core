module Producer
  module Core
    class Action
      require 'forwardable'

      extend Forwardable
      def_delegators :@env, :output, :remote
      def_delegators :remote, :fs

      attr_accessor :env, :arguments

      def initialize(env, *args)
        @env        = env
        @arguments  = args
      end
    end
  end
end
