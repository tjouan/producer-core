module Producer
  module Core
    class Recipe
      class << self
        def evaluate_from_file(filepath, env)
          DSL.evaluate(File.read(filepath), env)
        end
      end

      attr_accessor :tasks

      def initialize(tasks = [])
        @tasks = tasks
      end
    end
  end
end
