module Producer
  module Core
    module Actions
      class ShellCommand < Action
        def setup
          check_arguments_size! 1
          @command = arguments.first
        end

        def name
          'sh'
        end

        def apply
          remote.execute @command, output, error_output
        end
      end
    end
  end
end
