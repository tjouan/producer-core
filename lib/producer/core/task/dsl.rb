module Producer
  module Core
    class Task
      class DSL
        def initialize(&block)
          @block = block
        end

        def evaluate(env)
          instance_eval &@block
        rescue ConditionNotMetError
        rescue NameError => e
          raise TaskEvaluationError,
            "invalid task action `#{e.name}'",
            e.backtrace
        end

        def condition(&block)
          fail ConditionNotMetError unless block.call
        end
      end
    end
  end
end
