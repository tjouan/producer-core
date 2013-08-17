module Producer
  module Core
    class Test
      attr_reader :env, :arguments

      def initialize(env, *arguments)
        @env        = env
        @arguments  = arguments
      end
    end
  end
end
