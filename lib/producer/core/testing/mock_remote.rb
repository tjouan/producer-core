module Producer
  module Core
    module Testing
      class MockRemote < Remote
        def session
          fail 'no session for mock remote!'
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
            fail RemoteCommandExecutionError
          when 'type'
            fail RemoteCommandExecutionError unless %w[
              echo
              true
              false
              type
            ].include? tokens.first
          end

          output
        end
      end
    end
  end
end
