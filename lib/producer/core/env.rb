module Producer
  module Core
    class Env
      attr_accessor :output, :target

      def initialize(output: $stdout)
        @output = output
        @target = nil
      end

      def remote
        @remote ||= Remote.new(target)
      end
    end
  end
end
