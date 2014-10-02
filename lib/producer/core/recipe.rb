module Producer
  module Core
    class Recipe
      class << self
        def define_macro(name, block)
          [self, Task].each do |klass|
            klass.class_eval do
              define_method(name) { |*args| task name, *args, &block }
            end
          end
        end

        def compose_macro(name, macro, *base_args)
          [self, Task].each do |klass|
            klass.class_eval do
              define_method(name) { |*args| send macro, *(base_args + args) }
            end
          end
        end
      end

      attr_reader :env, :tasks

      def initialize(env)
        @env    = env
        @tasks  = []
      end

      def source(filepath)
        instance_eval File.read("./#{filepath}.rb"), "#{filepath}.rb"
      end

      def target(hostname = nil)
        if hostname then env.target ||= hostname else env.target end
      end

      def task(name, *args, &block)
        Task.evaluate(env, name, *args, &block).tap { |o| @tasks << o }
      end

      def macro(name, &block)
        self.class.class_eval { define_macro name, block }
      end

      def compose_macro(name, macro, *base_args)
        self.class.class_eval { compose_macro name, macro, *base_args}
      end

      def test_macro(name, &block)
        Condition.define_test(name, block)
      end

      def set(key, value)
        env[key] = value
      end

      def get(key)
        env[key]
      end
    end
  end
end
