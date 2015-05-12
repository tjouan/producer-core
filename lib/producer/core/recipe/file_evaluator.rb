module Producer
  module Core
    class Recipe
      class FileEvaluator
        class << self
          def evaluate(file_path, env)
            content = File.read(file_path)
            begin
              Recipe.new(env).tap { |o| o.instance_eval content, file_path }
            rescue Exception => e
              raise RecipeEvaluationError, e.message, [
                '%s (recipe)' % file_path,
                *e.backtrace
              ]
            end
          end
        end
      end
    end
  end
end
