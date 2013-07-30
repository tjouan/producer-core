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
    end
  end
end
