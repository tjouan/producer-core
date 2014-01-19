module Producer
  module Core
    class Recipe
      class DSL
        attr_reader :env, :code, :block, :tasks

        def initialize(env, code = nil, &block)
          @env    = env
          @code   = code
          @block  = block
          @tasks  = []
        end

        def evaluate
          if @code
            instance_eval @code
          else
            instance_eval &@block
          end
          self
        end

        def source(filepath)
          instance_eval File.read("./#{filepath}.rb"), "#{filepath}.rb"
        end

        def target(hostname)
          env.target = hostname
        end

        def task(name, *args, &block)
          @tasks << Task.evaluate(name, env, *args, &block)
        end

        def macro(name, &block)
          define_singleton_method(name) do |*args|
            task("#{name}", *args, &block)
          end
        end
      end
    end
  end
end
