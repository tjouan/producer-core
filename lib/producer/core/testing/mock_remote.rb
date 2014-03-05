module Producer
  module Core
    module Testing
      class MockRemote < Remote
        def session
          raise 'no session for mock remote!'
        end

        def execute(command, output = '')
          tokens = command.split
          program = tokens.shift

          case program
          when 'echo'
            output << tokens.join(' ') << "\n"
          when 'true'
            output << ''
          when 'false'
            raise RemoteCommandExecutionError
          end

          output
        end
      end
    end
  end
end
