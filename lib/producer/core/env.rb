module Producer
  module Core
    class Env
      attr_reader   :input, :output
      attr_accessor :target

      def initialize(input: $stdin, output: $stdout)
        @input  = input
        @output = output
        @target = nil
      end

      def remote
        @remote ||= Remote.new(target)
      end
    end
  end
end
