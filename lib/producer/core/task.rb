module Producer
  module Core
    class Task
      class << self
        def define_action(keyword, klass)
          define_method(keyword) do |*args|
            @actions << klass.new(@env, *args)
          end
        end

        def evaluate(env, name, *args, &block)
          new(env, name).tap { |o| o.instance_exec *args, &block }
        end
      end

      extend Forwardable
      def_delegators :@env, :target

      define_action :echo,                  Actions::Echo
      define_action :sh,                    Actions::ShellCommand

      define_action :mkdir,                 Actions::Mkdir
      define_action :file_append,           Actions::FileAppend
      define_action :file_replace_content,  Actions::FileReplaceContent
      define_action :file_write,            Actions::FileWriter

      attr_reader :name, :actions, :condition

      def initialize(env, name, actions = [], condition = true)
        @env        = env
        @name       = name
        @actions    = actions
        @condition  = condition
      end

      def to_s
        @name.to_s
      end

      def condition_met?
        !!@condition
      end

      def condition(&block)
        @condition = Condition.evaluate(@env, &block) if block
        @condition
      end

      def task(name, *args, &block)
        @actions << self.class.evaluate(@env, name, *args, &block)
      end

      def ask(question, choices, prompter: Prompter.new(@env.input, @env.output))
        prompter.prompt(question, choices)
      end

      def get(key)
        @env[key]
      end

      def template(path, variables = {})
        Template.new(path).render variables
      end
    end
  end
end
