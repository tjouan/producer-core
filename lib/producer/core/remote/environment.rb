module Producer
  module Core
    class Remote
      class Environment
        class << self
          def string_to_hash(str)
            Hash[str.each_line.map { |l| l.chomp.split '=', 2 }]
          end
        end
      end
    end
  end
end
