module Producer
  module Core
    class Task
      class DSL
        ConditionNotMetError = Class.new(StandardError)

        def initialize(&block)
          instance_eval &block
        rescue ConditionNotMetError
        end

        def condition(&block)
          raise ConditionNotMetError unless block.call
        end
      end
    end
  end
end
