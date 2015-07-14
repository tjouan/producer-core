module Producer
  module Core
    module Tests
      class HasEnv < Test
        def verify
          case arguments.size
          when 1
            remote.environment.key? key
          when 2
            remote.environment[key] == arguments.last
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
