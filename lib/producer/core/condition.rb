module Producer
  module Core
    class Condition
      class << self
        def evaluate(env, &block)
          DSL.evaluate(env, &block)
        end
      end

      def initialize(expression)
        @expression = expression
      end

      def !
        !@expression
      end
    end
  end
end
