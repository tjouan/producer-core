module Producer
  module Core
    class Condition
      class DSL
        class << self
          def evaluate(env, &block)
            dsl = new(&block)
            Condition.new(dsl.evaluate)
          end
        end

        def initialize(&block)
          @block = block
        end

        def evaluate
          @block.call
        end
      end
    end
  end
end
