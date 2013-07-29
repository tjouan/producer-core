module Producer
  module Core
    class Recipe
      attr_reader :code, :filepath

      def self.from_file(filepath)
        new(File.read(filepath), filepath)
      end

      def initialize(code, filepath = nil)
        @code     = code
        @filepath = filepath
      end

      def evaluate(env)
        dsl = DSL.new(@code).evaluate(env)
        dsl.tasks.each.map(&:evaluate)
      end


      class DSL
        attr_reader :tasks

        def initialize(code = nil, &block)
          @code   = code
          @block  = block
          @tasks  = []
        end

        def evaluate(env)
          if @code
            instance_eval @code
          else
            instance_eval &@block
          end
          self
        end


        private

        def source(filepath)
          instance_eval File.read("./#{filepath}.rb")
        end

        def task(name, &block)
          @tasks << Task.new(name, &block)
        end
      end
    end
  end
end
