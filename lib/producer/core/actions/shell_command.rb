module Producer
  module Core
    module Actions
      class ShellCommand < Action
        def apply
          env.output env.remote.execute(arguments.first)
        end
      end
    end
  end
end
