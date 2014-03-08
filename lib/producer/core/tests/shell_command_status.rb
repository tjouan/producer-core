module Producer
  module Core
    module Tests
      class ShellCommandStatus < Test
        def verify
          remote.execute(command)
          true
        rescue RemoteCommandExecutionError
          false
        end

        def command
          arguments.first
        end
      end
    end
  end
end
