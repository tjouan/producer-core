module Producer
  module Core
    class Task
      attr_reader :name

      def initialize(name, &block)
        @name   = name
        @block  = block
      end

      def evaluate(env)
        dsl = DSL.new(&@block)
        dsl.evaluate(env)
        dsl.actions.map(&:apply)
      end
    end
  end
end
