module Producer
  module Core
    class Recipe
      RecipeEvaluationError = Class.new(StandardError)

      attr_reader :code, :filepath

      def self.from_file(filepath)
        new(File.read(filepath), filepath)
      end

      def initialize(code, filepath = nil)
        @code     = code
        @filepath = filepath
      end

      def evaluate(env)
        dsl = DSL.new(@code).evaluate(env)
        dsl.tasks.map { |e| e.evaluate env }
      end
    end
  end
end
