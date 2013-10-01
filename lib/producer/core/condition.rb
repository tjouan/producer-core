module Producer
  module Core
    class Condition
      class << self
        def evaluate(env, &block)
          DSL.evaluate(env, &block)
        end
      end

      def initialize(tests, return_value = nil)
        @tests        = tests
        @return_value = return_value
      end

      def met?
        return !!@return_value if @tests.empty?
        @tests.each { |t| return false unless t.pass? }
        true
      end

      def !
        !met?
      end
    end
  end
end
