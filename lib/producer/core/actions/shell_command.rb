module Producer
  module Core
    module Actions
      class ShellCommand < Action
        def apply
          output.puts remote.execute(arguments.first)
        end
      end
    end
  end
end
