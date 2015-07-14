module Producer
  module Core
    module Testing
      class MockRemote < Remote
        def session
          fail 'no session for mock remote!'
        end

        def execute command, output = '', error_output = ''
          program, *args = command.gsub(/\d?>.*/, '').split
          program_output = command =~ />&2\z/ ? error_output : output
          send "handle_program_#{program}", args, program_output
          output
        end

      private

        def handle_program_echo args, output
          output << args.join(' ') << "\n"
        end

        def handle_program_true _, output
          output << ''
        end

        def handle_program_false *_
          fail RemoteCommandExecutionError
        end

        def handle_program_type args, _
          fail RemoteCommandExecutionError unless %w[
            echo
            true
            false
            type
          ].include? args.first
        end
      end
    end
  end
end
