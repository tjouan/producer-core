module Producer
  module Core
    class Condition
      class << self
        def evaluate(env, &block)
          dsl = DSL.new(env, &block)
          return_value = dsl.evaluate
          Condition.new(dsl.tests, return_value)
        end
      end

      attr_reader :tests, :return_value

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
