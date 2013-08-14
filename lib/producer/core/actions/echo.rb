module Producer
  module Core
    module Actions
      class Echo < Action
        def apply
          env.output arguments.first
        end
      end
    end
  end
end
