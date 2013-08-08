module Producer
  module Core
    class Task
      attr_reader :name, :actions, :condition

      def self.evaluate(name, env, &block)
        DSL.evaluate(name, env, &block)
      end

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
