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

        attr_reader :env, :block, :actions

        def initialize(env, &block)
          @env        = env
          @block      = block
          @actions    = []
          @condition  = true
        end

        def evaluate(*args)
          instance_exec *args, &@block
        end

        def condition(&block)
          @condition = Condition.evaluate(@env, &block) if block
          @condition
        end
      end
    end
  end
end
