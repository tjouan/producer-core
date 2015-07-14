module Producer
  module Core
    module Testing
      class MockRemote < Remote
        def session
          fail 'no session for mock remote!'
        end

        def execute command, output = '', error_output = ''
          tokens = command.gsub(/\d?>.*/, '').split
          program = tokens.shift

          case program
          when 'echo'
            out = tokens.join(' ') << "\n"
            if command =~ />&2\z/
              error_output << out
            else
              output << out
            end
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
