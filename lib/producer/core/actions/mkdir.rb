module Producer
  module Core
    module Actions
      class Mkdir < Action
        def apply
          fs.mkdir path
        end

        def path
          arguments.first
        end
      end
    end
  end
end
