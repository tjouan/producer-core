module Producer
  module Core
    class Recipe
      class FileEvaluator
        class << self
          def evaluate(file_path, env)
            content = File.read(file_path)
            Recipe.new(env).tap { |o| o.instance_eval content, file_path }
          end
        end
      end
    end
  end
end
