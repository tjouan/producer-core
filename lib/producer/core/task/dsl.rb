module Producer
  module Core
    class Task
      class DSL
        class << self
          def define_action(keyword, klass)
            define_method(keyword) do |*args|
              @actions << klass.new(@env, *args)
            end
          end
        end

        define_action :echo,  Actions::Echo
        define_action :sh,    Actions::ShellCommand

        define_action :file_write,  Actions::FileWriter

        attr_accessor :actions

        def initialize(&block)
          @block      = block
          @actions    = []
          @condition  = true
        end

        def evaluate(env)
          @env = env
          instance_eval &@block
        end

        def condition(&block)
          @condition = Condition.evaluate(@env, &block) if block
          @condition
        end
      end
    end
  end
end
