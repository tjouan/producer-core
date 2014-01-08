module Producer
  module Core
    module Actions
      class ShellCommand < Action
        def apply
          output.puts env.remote.execute(arguments.first)
        end
      end
    end
  end
end
