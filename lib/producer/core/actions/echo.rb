module Producer
  module Core
    module Actions
      class Echo < Action
        def name
          'echo'
        end

        def apply
          output.puts arguments
        end
      end
    end
  end
end
