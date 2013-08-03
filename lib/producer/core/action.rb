module Producer
  module Core
    class Action
      attr_accessor :env, :arguments

      def initialize(env, *args)
        @env        = env
        @arguments  = args
      end
    end
  end
end
