module Producer
  module Core
    module Actions
      class ShellCommand < Action
        def apply
          remote.execute(arguments.first, output)
          output.puts
        end
      end
    end
  end
end
