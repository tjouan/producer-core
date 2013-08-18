module Producer
  module Core
    class Tests
      class HasEnv < Test
        def success?
          env.remote.environment.has_key? arguments.first.to_s.upcase
        end
      end
    end
  end
end
