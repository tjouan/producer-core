module Producer
  module Core
    class Recipe
      class << self
        def evaluate_from_file(filepath, env)
          dsl = DSL.new(env, File.read(filepath)).evaluate
          Recipe.new(dsl.tasks)
        end
      end

      attr_accessor :tasks

      def initialize(tasks = [])
        @tasks = tasks
      end
    end
  end
end
