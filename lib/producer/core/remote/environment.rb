module Producer
  module Core
    class Remote
      class Environment
        class << self
          def string_to_hash(str)
            Hash[str.each_line.map { |l| l.chomp.split '=', 2 }]
          end

          def new_from_string(str)
            new string_to_hash str
          end
        end

        extend Forwardable
        def_delegators :@variables, :[], :key?

        attr_reader :variables

        def initialize(variables)
          @variables = variables
        end
      end
    end
  end
end
