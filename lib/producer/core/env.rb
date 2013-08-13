module Producer
  module Core
    class Env
      attr_writer   :output
      attr_accessor :target

      def initialize
        @output = $stdout
        @target = nil
      end

      def output(str)
        @output.puts str
      end

      def remote
        @remote ||= Remote.new(target)
      end
    end
  end
end
