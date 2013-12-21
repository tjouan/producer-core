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

        require 'forwardable'

        extend Forwardable
        def_delegator :@variables, :has_key?

        def initialize(variables)
          @variables = variables
        end
      end
    end
  end
end
