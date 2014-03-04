module Producer
  module Core
    module Testing
      class MockRemote < Remote
        def session
          raise 'no session for mock remote!'
        end

        def execute(command)
          tokens = command.split
          program = tokens.shift

          case program
          when 'echo'
            tokens.join ' '
          when 'true'
            ''
          when 'false'
            raise RemoteCommandExecutionError
          end
        end
      end
    end
  end
end
