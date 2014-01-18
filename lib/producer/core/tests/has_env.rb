module Producer
  module Core
    module Tests
      class HasEnv < Test
        def verify
          remote.environment.key? arguments.first.to_s.upcase
        end
      end
    end
  end
end
