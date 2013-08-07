module Producer
  module Core
    class Task
      class DSL
        class << self
          def define_action(keyword, klass)
            define_method(keyword) do |*args|
              @actions << klass.new(@env, *args)
            end
          end
        end

        attr_accessor :actions

        def initialize(&block)
          @block    = block
          @actions  = []
        end

        def evaluate(env)
          @env = env
          instance_eval &@block
        rescue ConditionNotMetError
        rescue NameError => e
          raise TaskEvaluationError,
            "invalid task action `#{e.name}'",
            e.backtrace
        end

        private

        def condition(&block)
          fail ConditionNotMetError unless block.call
        end
      end
    end
  end
end
