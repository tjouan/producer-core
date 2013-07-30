module Producer
  module Core
    class Task
      attr_reader :name

      def initialize(name, &block)
        @name   = name
        @block  = block
      end

      def evaluate(env)
        DSL.new(&@block).evaluate(env)
      end
    end
  end
end
