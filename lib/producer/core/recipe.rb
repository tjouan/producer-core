module Producer
  module Core
    class Recipe
      attr_reader :code

      def self.from_file(filepath)
        new(File.read(filepath))
      end

      def initialize(code)
        @code = code
      end

      def evaluate
        Object.new.instance_eval @code
      end
    end
  end
end
