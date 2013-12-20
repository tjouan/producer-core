module Producer
  module Core
    class Task
      class << self
        def evaluate(name, env, &block)
          dsl = DSL.new(&block)
          dsl.evaluate(env)
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
