module Producer
  module Core
    module Actions
      class ShellCommand < Action
        def apply
          remote.execute(arguments.first, output)
        end
      end
    end
  end
end
