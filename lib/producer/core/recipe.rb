module Producer
  module Core
    class Recipe
      attr_reader :code, :filepath, :tasks

      def self.from_file(filepath)
        new(File.read(filepath), filepath)
      end

      def initialize(code, filepath = nil)
        @code     = code
        @filepath = filepath
        @tasks    = []
      end

      def evaluate(env)
        dsl = DSL.new(@code).evaluate(env)
        dsl.tasks.map { |e| e.evaluate env }
        @tasks = dsl.tasks
      end
    end
  end
end
