module Producer
  module Core
    class Task
      attr_reader :name, :actions

      def initialize(name, &block)
        @name     = name
        @block    = block
        @actions  = []
      end

      def evaluate(env)
        dsl = DSL.new(&@block)
        dsl.evaluate(env)
        @actions = dsl.actions
      end
    end
  end
end
