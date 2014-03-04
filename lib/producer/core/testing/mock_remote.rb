module Producer
  module Core
    module Testing
      class MockRemote < Remote
        def session
          raise 'no session for mock remote!'
        end
      end
    end
  end
end
