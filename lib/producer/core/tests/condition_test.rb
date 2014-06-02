module Producer
  module Core
    module Tests
      class ConditionTest < Test
        def verify
          condition.met?
        end

        def condition
          Condition.evaluate(env, *condition_args, &condition_block)
        end

        def condition_args
          arguments.drop 1
        end

        def condition_block
          arguments.first
        end
      end
    end
  end
end
