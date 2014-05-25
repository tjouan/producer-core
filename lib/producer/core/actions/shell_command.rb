module Producer
  module Core
    module Actions
      class ShellCommand < Action
        def name
          'sh'
        end

        def apply
          remote.execute(arguments.first, output)
        end
      end
    end
  end
end
