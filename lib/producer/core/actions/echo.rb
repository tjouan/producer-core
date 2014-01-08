module Producer
  module Core
    module Actions
      class Echo < Action
        def apply
          output.puts arguments.first
        end
      end
    end
  end
end
