module Producer
  module Core
    module Tests
      class HasEnv < Test
        def verify
          case arguments.size
            when 1 then remote.environment.key? key
            when 2 then remote.environment[key] == arguments.last
          end
        end

      private

        def key
          arguments.first.to_s.upcase
        end
      end
    end
  end
end
