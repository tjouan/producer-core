module Producer
  module Core
    class Task
      attr_reader :name, :actions

      def self.evaluate(name, env, &block)
        DSL.evaluate(name, env, &block)
      end

      def initialize(name, actions = [])
        @name     = name
        @actions  = actions
      end
    end
  end
end
