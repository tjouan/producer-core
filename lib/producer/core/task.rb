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
      def_delegators  :@name, :to_s
      def_delegators  :@env,  :target
      def_delegator   :@env,  :[]=, :set
      def_delegator   :@env,  :[], :get
      def_delegator   :@env,  :key?, :set?
      def_delegator   :@env,  :recipe_argv

      define_action :echo,                  Actions::Echo
      define_action :sh,                    Actions::ShellCommand

      define_action :mkdir,                 Actions::Mkdir
      define_action :file_append,           Actions::FileAppend
      define_action :file_replace_content,  Actions::FileReplaceContent
      define_action :file_write,            Actions::FileWriter
      define_action :yaml_write,            Actions::YAMLWriter

      attr_reader :name, :actions, :condition

      def initialize(env, name, actions = [], condition = true)
        @env        = env
        @name       = name
        @actions    = actions
        @condition  = condition
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

      def ask(question, choices, prompter: build_prompter)
        prompter.prompt(question, choices)
      end

      def template(path, variables = {})
        Template.new(path).render variables
      end


      private

      def build_prompter
        Prompter.new(@env.input, @env.output)
      end
    end
  end
end
