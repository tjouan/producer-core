module Producer
  module Core
    class Recipe
      class DSL
        attr_reader :tasks

        def self.evaluate(code, env)
          dsl = new(code).evaluate(env)
          Recipe.new(dsl.tasks)
        end

        def initialize(code = nil, &block)
          @code   = code
          @block  = block
          @tasks  = []
        end

        def evaluate(env)
          @env = env
          if @code
            instance_eval @code
          else
            instance_eval &@block
          end
          @tasks.each { |e| e.evaluate env }
          self
        end

        private

        def env
          @env
        end

        def source(filepath)
          instance_eval File.read("./#{filepath}.rb"), "#{filepath}.rb"
        end

        def target(hostname)
          env.target = hostname
        end

        def task(name, &block)
          @tasks << Task.new(name, &block)
        end
      end
    end
  end
end
