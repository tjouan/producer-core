module Producer
  module Core
    class Recipe
      attr_accessor :tasks

      def self.evaluate_from_file(filepath, env)
        DSL.evaluate(File.read(filepath), env)
      end

      def initialize(tasks = [])
        @tasks = tasks
      end
    end
  end
end
