module Producer
  module Core
    module Tests
      class HasExecutable < Test
        def verify
          remote.execute "type #{arguments.first}"
          true
        rescue RemoteCommandExecutionError
          false
        end
      end
    end
  end
end
