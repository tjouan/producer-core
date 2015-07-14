module Producer
  module Core
    module Tests
      class ShellCommandStatus < Test
        extend Forwardable
        def_delegator :@arguments, :first, :command

        def verify
          remote.execute command
          true
        rescue RemoteCommandExecutionError
          false
        end
      end
    end
  end
end
