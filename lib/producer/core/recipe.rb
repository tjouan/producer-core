module Producer
  module Core
    class Recipe
      class << self
        def define_macro(name, block)
          define_method(name) { |*args| task name, *args, &block }
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

      def target(hostname)
        env.target ||= hostname
      end

      def task(name, *args, &block)
        @tasks << Task.evaluate(env, name, *args, &block)
      end

      def macro(name, &block)
        define_singleton_method(name) do |*args|
          task("#{name}", *args, &block)
        end
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
