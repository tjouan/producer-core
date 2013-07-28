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
        dsl = DSL.new(@code)
      end


      class DSL
        def initialize(code = nil, &block)
          if code
            instance_eval code
          else
            instance_eval &block
          end
        end
      end
    end
  end
end
