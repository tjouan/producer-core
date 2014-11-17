module Producer
  module Core
    module Tests
      class ConditionTest < Test
        extend Forwardable
        def_delegator :@arguments,  :first,  :condition_block
        def_delegator :condition,   :met?,   :verify

        def condition
          Condition.evaluate(env, *condition_args, &condition_block)
        end

        def condition_args
          arguments.drop 1
        end
      end
    end
  end
end
