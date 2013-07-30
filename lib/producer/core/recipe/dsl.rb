module Producer
  module Core
    class Recipe
      class DSL
        attr_reader :tasks

        def initialize(code = nil, &block)
          @code   = code
          @block  = block
          @tasks  = []
        end

        def evaluate(env)
          if @code
            instance_eval @code, env.current_recipe.filepath
          else
            instance_eval &@block
          end
          self
        rescue NameError => e
          err = RecipeEvaluationError.new("invalid recipe keyword `#{e.name}'")
          err.set_backtrace e.backtrace.reject { |l| l =~ /\/producer-core\// }
          raise err
        end


        private

        def source(filepath)
          instance_eval File.read("./#{filepath}.rb"), "#{filepath}.rb"
        end

        def task(name, &block)
          @tasks << Task.new(name, &block)
        end
      end
    end
  end
end
