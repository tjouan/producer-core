module Producer
  module Core
    class Env
      attr_reader   :current_recipe
      attr_writer   :output
      attr_accessor :target

      def initialize(recipe = nil)
        @current_recipe = recipe
        @output         = $stdout
        @target         = nil
      end

      def output(str)
        @output.puts str
      end
    end
  end
end
