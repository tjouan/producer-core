module Producer
  module Core
    class Task
      attr_reader :name

      def initialize(name, &block)
        @name   = name
        @block  = block
      end

      def evaluate
        DSL.new &@block
      end


      class DSL
        ConditionNotMetError = Class.new(RuntimeError)

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
