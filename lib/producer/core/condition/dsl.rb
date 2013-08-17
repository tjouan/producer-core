module Producer
  module Core
    class Condition
      class DSL
        class << self
          def evaluate(env, &block)
            dsl = new(env, &block)
            return_value = dsl.evaluate
            Condition.new(dsl.tests, return_value)
          end

          def define_test(keyword, klass)
            define_method(keyword) do |*args|
              @tests << klass.new(@env, *args)
            end
          end
        end

        attr_accessor :tests

        def initialize(env, &block)
          @env    = env
          @block  = block
          @tests  = []
        end

        def evaluate
          instance_eval &@block
        end
      end
    end
  end
end
