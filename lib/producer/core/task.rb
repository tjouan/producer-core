module Producer
  module Core
    class Task
      class << self
        def evaluate(name, env, *args, &block)
          dsl = DSL.new(env, &block)
          dsl.evaluate(*args)
          Task.new(name, dsl.actions, dsl.condition)
        end
      end

      attr_reader :name, :actions, :condition

      def initialize(name, actions = [], condition = true)
        @name       = name
        @actions    = actions
        @condition  = condition
      end

      def condition_met?
        !!@condition
      end
    end
  end
end
