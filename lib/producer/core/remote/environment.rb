module Producer
  module Core
    class Remote
      class Environment
        require 'forwardable'

        extend Forwardable
        def_delegator :@variables, :has_key?

        def initialize(variables)
          case variables
          when String
            @variables = parse_from_string variables
          else
            @variables = variables
          end
        end

        private

        def parse_from_string(str)
          Hash[str.each_line.map { |l| l.chomp.split '=', 2 }]
        end
      end
    end
  end
end
