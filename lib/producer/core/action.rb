module Producer
  module Core
    class Action
      INSPECT_ARGUMENTS_SUM_LEN = 68.freeze

      extend Forwardable
      def_delegators :@env, :input, :output, :error_output, :remote
      def_delegators :remote, :fs

      attr_reader :env, :arguments, :options

      def initialize(env, *args, **options)
        @env        = env
        @arguments  = args
        @options    = options
      end

      def name
        self.class.name.split('::').last.downcase
      end

      def to_s
        [name, inspect_arguments].join ' '
      end


      private

      def inspect_arguments
        @arguments.inspect[0, INSPECT_ARGUMENTS_SUM_LEN - name.length]
      end
    end
  end
end
